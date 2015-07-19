'use strict'
root = @

makeAudio = (title, src, img) ->
	aud = document.createElement 'audio'

	aud.setAttribute 'data-title', title if title
	aud.setAttribute 'src', src if src
	aud.setAttribute 'data-img', img if img

	return aud

fireSongEvent = (instance) ->
	try instance.callbacks.forEach (callback) ->
		callback instance.getSong()


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
	history: []
	
	songChange: (callback) ->
		@callbacks.push(callback)
	
	updateHistory: (song) ->
		history = root.Song.prototype.history
		last = history.length - 1
		
		if song is history[last]
			undefined
		else
			history.push song
	
	shuffle: ->
		@songNumber = 0
	
		@playlist.sort ->
			(Math.floor Math.random() * 3) - 1
	
		@resetSongs()
		fireSongEvent(@)
	
		@playlist
	
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
			@resetSongs()
			return audio
	
		else if @songNumber is 0 and @repeat
			@skipTo (@playlist.length - 1)
	
		else if @songNumber > 0
			@skipTo (@songNumber - 1)
	
	skipTo: (songNum) ->
		return undefined if songNum >= @playlist.length
		return undefined if songNum < 0
		
		if songNum or songNum is 0
			@resetSongs
			@songNumber = songNum
			
			@updateHistory @getSong()
			fireSongEvent(@)
			
			return @getSong()
	
	resetSongs: ->
		for song in @playlist
			try
				song.pause()
				song.currentTime = 0
	
	getSong: ->
		return @playlist[@songNumber]
	
	getAlbum: (audio) ->
		if not audio
			audio = @getSong()
			
		src = audio.getAttribute 'data-img'
		img = document.createElement 'img'
		img.src = src
		
		return img
	
	getTitle: (audio) ->
		if not audio
			audio = @getSong()
		
		try
			title = audio.getAttribute 'data-title'
		catch
			title = '';
		return title

	add: (playlist) ->
		if playlist.length > 0 and typeof playlist is 'object'
			# treat playlist as an object array
			for song in playlist
				audioTag = makeAudio song.title,
				song.src,
				song.img
		
				@playlist.push audioTag
			return @playlist
		
		else if typeof playlist is 'object'
			# treat playlist as one object
			audioTag = makeAudio playlist.title,
			playlist.src,
			playlist.img
			
			@playlist.push audioTag
}