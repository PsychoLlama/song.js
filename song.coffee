'use strict'
try
	new Audio()
catch
	return @Playlist = undefined

root = @

# Generic methods
getSongs = (url, playlist) ->
	request = new XMLHttpRequest()
	request.open 'get', url, true
	request.addEventListener 'load', ->
		songs = JSON.parse request.responseText
		playlist.add songs
		playlist.songRequest = null
	
	request.send()
	playlist.songRequest = request
	
	return playlist

dismantle = (array, playlist) ->
	for object in array
		playlist.add object

makeAudio = (song) ->
	audio = new Audio()
	if song.src then audio.src = song.src
	if song.title
		audio.setAttribute 'data-title', song.title
	if song.img
		audio.setAttribute 'data-img', song.img

	return audio

fireEvent = (playlist, callbacks) ->
	try
		for callback in callbacks
			callback playlist.getSong()

clean = (array) ->
	# Returns an array without any falsy values
	value for value in array when value

resetSongs = (playlist, exception) ->
	playlist = playlist.songs
	for song in playlist when song isnt exception
		try
			song.pause()
			song.currentTime = 0
	
	return playlist


class Playlist
	constructor: (@name) ->
		
		@songRequest = null
		@songs = []
		
		@songNumber = 0
		@event =
			song: []
			playlist: []
		
		@repeat = (->
			# Hide access to repeatState
			# through a get/set closure
			repeatState = false
			return (bool) ->
				if bool is undefined
					return repeatState
					
				if typeof bool is 'boolean'
					repeatState = bool
				
				return @
			)()
	
	
	# Inherited methods
	onChange: (type, callback) ->
		if type.toLowerCase() is 'song'
			@event.song.push callback
		else if type.toLowerCase() is 'playlist'
			@event.playlist.push callback
		
		return @

	shuffle: ->
		@songNumber = 0
	
		@songs.sort ->
			(Math.floor Math.random() * 3) - 1
	
		resetSongs(@)
		fireEvent @, @event.playlist
	
		return @
	
	play: ->
		@after =>
			@getSong()?.play()
			return @
	
	pause: ->
		@getSong()?.pause()
		return @
	
	next: ->
		lastSong = @songs.length - 1
		onLastSong = @songNumber is lastSong
	
		if onLastSong and @repeat() is on
			return @skipTo(0)
	
		if onLastSong and @repeat() is off
			return undefined
	
		else if @songNumber < lastSong
			return @skipTo (@songNumber + 1)
	
	previous: ->
		audio = @getSong()
	
		if audio.currentTime > 5
			resetSongs(@)
			return @
	
		if @songNumber is 0 and @repeat() is on
			return @skipTo (@songs.length - 1)
	
		if @songNumber > 0
			return @skipTo (@songNumber - 1)
	
	skipTo: (songNum) ->
		if (0 <= songNum < @songs.length) is false
			return
		return if songNum is undefined
		
		resetSongs(@)
		@songNumber = songNum
		
		fireEvent @, @event.song
		
		return @
		
	
	getSong: (songNum) ->
		if not songNum
			return @songs[@songNumber]
		
		if songNum >= 0 and songNum < @songs.length
			return @songs[songNum]
	
	album: (audio = @getSong()) ->
		
		src = audio.getAttribute 'data-img'
		return if src is null
		
		img = document.createElement 'img'
		img.src = src
		
		return img
	
	title: (audio = @getSong()) ->
		songTitle = audio.getAttribute 'data-title'
		if songTitle
			return songTitle
		else return undefined

	add: (data) ->
		if typeof data is 'string'
			return getSongs data, @
		
		if data.length > 0
			dismantle data, @
				
		else if data.tagName is 'AUDIO'
			@songs.push data
		else if typeof data is 'object'
			@songs.push makeAudio data
		
		fireEvent @, @event.playlist
		
		return @
	
	remove: (songNum) ->
		if 0 <= songNum < @songs.length
			
			try @songs[songNum].pause()
			delete @songs[songNum]
			@songs = clean(@songs)
			fireEvent @, @event.playlist
			
			if @songNumber is songNum
				@songNumber = 0
				fireEvent @, @event.song
			else if @songNumber > songNum
				@songNumber--
			
			return @
	
	# Only used internally:
	# If you need to use "this" in an after callback,
	# use a fat function arrow.
	after: (callback) ->
		if @songRequest isnt null
			@songRequest.addEventListener 'load', =>
				callback(@)
		else callback(@)
		
		return @
	
	each: (callback) ->
		try
			for song in @songs
				callback(song, _i)
		
		return @
	
	clear: ->
		@after =>
			@each =>
				@remove 0

root.Playlist = Playlist