'use strict'
root = this

makeAudio = (title, src, img) ->
	aud = document.createElement 'audio'

	aud.setAttribute 'data-title', title if title
	aud.setAttribute 'src', src if src
	aud.setAttribute 'data-img', img if img

	return aud

add = (playlist, destination) ->
	return undefined if playlist.length is 0

	for song in playlist
		audio = makeAudio song.title,
		song.src,
		song.img

		destination.push audio
	return destination

fireSongEvent = (playlist) ->
	try playlist.callbacks.forEach (callback) ->
		callback playlist.getSong()

root.Song = (playlist) ->
	this.repeat = false

	this.playlist = []
	add playlist, this.playlist

	this.songNumber = 0
	this.callbacks = []
	this.songChange = (callback) ->
		this.callbacks.push(callback)
	
	return this

root.Song.prototype = {
	constructor: root.Song
	history: []
	updateHistory: (song) ->
		history = root.Song.prototype.history
		last = history.length - 1
		
		if song is history[last]
			undefined
		else
			history.push song
	
	shuffle: ->
		this.songNumber = 0
	
		this.playlist.sort ->
			(Math.floor Math.random() * 3) - 1
	
		this.resetSongs()
		fireSongEvent(this)
	
		this.playlist
	
	next: ->
		lastSong = this.playlist.length - 1
		isLastSong = this.songNumber is lastSong
		repeat = this.repeat
	
		if isLastSong and repeat
			this.skipTo(0)
	
		else if isLastSong and not repeat
			return undefined
	
		else if this.songNumber < lastSong
			this.skipTo (this.songNumber + 1)
	
	previous: ->
		audio = this.getSong()
	
		if audio.currentTime < 5 and audio.currentTime > 0
			this.resetSongs()
			return audio
	
		else if this.songNumber is 0 and this.repeat
			this.skipTo (this.playlist.length - 1)
	
		else if this.songNumber > 0
			this.skipTo (this.songNumber - 1)
	
	skipTo: (songNum) ->
		return undefined if songNum >= this.playlist.length
		return undefined if songNum < 0
		
		if songNum or songNum is 0
			this.resetSongs
			this.songNumber = songNum
			
			this.updateHistory this.getSong()
			fireSongEvent(this)
			
			return this.getSong()
	
	resetSongs: ->
		for song in this.playlist
			try
				song.pause()
				song.currentTime = 0
	
	getSong: ->
		return this.playlist[this.songNumber]
	
	getAlbum: (audio) ->
		if not audio
			audio = this.getSong()
			
		src = audio.getAttribute 'data-img'
		img = document.createElement 'img'
		img.src = src
		
		return img
	
	getTitle: (audio) ->
		if not audio
			audio = this.getSong()
		
		try
			title = audio.getAttribute 'data-title'
		catch
			title = '';
		return title
}