'use strict'
root = @

# Generic methods
makeAudio = (song) ->
	audio = new Audio()
	audio.src = song.src if song.src

	audio.setAttribute 'data-title', song.title if song.title
	audio.setAttribute 'data-img', song.img if song.img

	return audio

fireSongEvent = (instance) ->
	try
		for callback in instance.callbacks
			callback instance.getSong()

clean = (array) ->
	# Returns an array without any falsy values
	value for value in array when value

resetSongs = (instance) ->
	playlist = instance.playlist
	for song in playlist
		try
			song.pause()
			song.currentTime = 0
	
	return instance


# Song constructor
root.Song = (playlist) ->
	@repeat = false

	@playlist = []
	@add playlist

	@songNumber = 0
	@callbacks = []
	
	return @


# Built-in methods
root.Song.prototype = {
	
	constructor: root.Song
	
	songChange: (callback) ->
		@callbacks.push(callback)
		
		return @
	
	shuffle: ->
		@songNumber = 0
	
		@playlist.sort ->
			(Math.floor Math.random() * 3) - 1
	
		resetSongs(@)
		fireSongEvent @
	
		return @
	
	play: ->
		song = @getSong()
		if song
			song.play()
			return @
	
	pause: ->
		song = @getSong()
		if song
			song.pause()
			return @
	
	next: ->
		lastSong = @playlist.length - 1
		isLastSong = @songNumber is lastSong
		repeat = @repeat
	
		if isLastSong and repeat
			@skipTo(0)
	
		else if isLastSong and not repeat
			return undefined
	
		else if @songNumber < lastSong
			@skipTo (@songNumber + 1)
	
	previous: ->
		audio = @getSong()
	
		if audio.currentTime < 5 and audio.currentTime > 0
			resetSongs(@)
			return @
	
		else if @songNumber is 0 and @repeat
			@skipTo (@playlist.length - 1)
	
		else if @songNumber > 0
			@skipTo (@songNumber - 1)
	
	skipTo: (songNum) ->
		return undefined if songNum >= @playlist.length
		return undefined if songNum < 0
		
		if songNum or songNum is 0
			resetSongs(@)
			@songNumber = songNum
			
			fireSongEvent @
			
			return @
	
	getSong: (songNum) ->
		if not songNum
			return @playlist[@songNumber]
		
		if songNum >= 0 and songNum < @playlist.length
			return @playlist[songNum]
	
	album: (audio) ->
		audio ?= @getSong()
		
		src = audio.getAttribute 'data-img'
		return if src is null
		
		img = document.createElement 'img'
		img.src = src
		
		return img
	
	title: (audio) ->
		audio ?= @getSong()
		
		try
			songTitle = audio.getAttribute 'data-title'
		catch
			songTitle = '';
		return songTitle

	add: (data) ->
		return null if typeof data isnt 'object'
		
		if data.length > 0
			# It's a playlist
			
			for song in data
				@playlist.push makeAudio song
				
		else if data.tagName is 'AUDIO'
			# It's an <audio> tag
			
			@playlist.push data
		else
			# User passed a single object
			@playlist.push makeAudio data
		
		fireSongEvent @
		
		return @
	
	remove: (songNum) ->
		if songNum >= 0 and songNum < @playlist.length
			
			delete @playlist[songNum]
			@playlist = clean(@playlist)
			fireSongEvent @
			
			if @songNumber is songNum
				@songNumber = 0
			else if @songNumber > songNum
				@songNumber--
			
			return @
	
	each: (callback) ->
		try
			for song in @playlist
				callback(song)
		
		return @
}