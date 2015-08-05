'use strict'
try
	new Audio()
catch
	return @Playlist = undefined

root = @

# Generic methods
netRequest = (url) ->
	request = new XMLHttpRequest()
	request.open 'get', url, true
	request.addEventListener 'load', =>
		songs = JSON.parse request.responseText
		@add songs
		@songRequest = null
	
	request.send()
	@songRequest = request
	
	return @

dismantle = (array) ->
	for object in array
		@add object
	
	return @

Song = (song, playlist) ->
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
			paused: []
		
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
	onChange: (type, callback) =>
		type = type.toLowerCase()
		
		return null if type of @event is false
		@event[type].push callback
		
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
		switch data.constructor
			when String
				return netRequest.call @, data
			when Array
				return dismantle.call @, data
			when Object
				return @add Song data
		
		return if data.tagName isnt 'AUDIO'
		
		@songs.push data
		fireEvent @, @event.playlist
		
		data.addEventListener 'playing', ->
			console.log @
		
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