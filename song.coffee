'use strict'
root = @

# Generic methods
makeAudio = (song) ->
	audio = new Audio()
	if song.src then audio.src = song.src
	if song.title
		audio.setAttribute 'data-title', song.title
	if song.img
		audio.setAttribute 'data-img', song.img

	return audio

fireSongEvent = (instance) ->
	try
		for callback in instance.callbacks
			callback instance.getSong()

clean = (array) ->
	# Returns an array without any falsy values
	value for value in array when value
	

resetSongs = (instance) ->
	playlist = instance.songs
	for song in playlist
		try
			song.pause()
			song.currentTime = 0
	
	return instance


class Playlist
	constructor: (@name) ->
		@repeatState = false
		
		@songs = []
		
		@songNumber = 0
		@callbacks = []
	
	
	# Inherited methods
	songChange: (callback) ->
		@callbacks.push callback
		
		return @

	shuffle: ->
		@songNumber = 0
	
		@songs.sort ->
			(Math.floor Math.random() * 3) - 1
	
		resetSongs(@)
		fireSongEvent @
	
		return @
	
	play: ->
		song = @getSong()
		song?.play()
		return @
	
	pause: ->
		song = @getSong()
		song?.pause()
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
		
		fireSongEvent @
		
		return @
	
	repeat: (bool) ->
		if bool is undefined
			return @repeatState
		if typeof bool is 'boolean'
			@repeatState = bool
		
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
		return null if typeof data isnt 'object'
		
		if data.length > 0
			# It's a playlist
			
			for song in data
				@songs.push makeAudio song
				
		else if data.tagName is 'AUDIO'
			# It's an <audio> tag
			
			@songs.push data
		else
			# User passed a single object
			@songs.push makeAudio data
		
		fireSongEvent @
		
		return @
	
	remove: (songNum) ->
		if 0 <= songNum < @songs.length
			
			delete @songs[songNum]
			@songs = clean(@songs)
			fireSongEvent @
			
			if @songNumber is songNum
				@songNumber = 0
			else if @songNumber > songNum
				@songNumber--
			
			return @
	
	each: (callback) ->
		try
			for song in @songs
				callback(song, _i)
		
		return @
		
root.Playlist = Playlist