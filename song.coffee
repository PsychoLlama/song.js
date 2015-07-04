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

		destination.push aud
	return destination

root.Song = (playlist) ->
	this.repeat = false

	this.playlist = []
	add playlist, this.playlist

	this.songNumber = 0
	this.onsongchange
	return this

root.Song.prototype.history = []

root.Song.prototype.updateHistory = (song) ->
	history = root.Song.prototype.history
	last = history.length - 1

	if song is history[last]
		undefined
	else
		history.push song

root.Song.prototype.shuffle = ->
	this.songNumber = 0

	this.playlist.sort ->
		(Math.floor Math.random() * 3) - 1

	this.resetSongs()
	try this.onsongchange()

	this.playlist

root.Song.next = ->
	lastSong = this.playlist.length - 1
	isLastSong = this.songNumber is lastSong
	repeat = this.repeat

	if isLastSong and repeat
		this.songNumber = 0
		return finalize()

	else if isLastSong and not repeat
		return undefined

	else if this.songNumber < lastSong
		this.songNumber
		return finalize()

	finalize = ->
		this.updateHistory this.getSong()
		try onsongchange()
		this.getSong()

root.Song.previous = ->
	aud = this.getSong()

	if aud.currentTime < 5
		this.resetSongs()
		return aud

	else if this.songNumber is 0
		this.songNumber = this.playlist.length - 1
		return finalize()

	else if this.songNumber > 0
		this.songNumber--
		return finalize()

	finalize = ->
		this.resetSongs()
		this.updateHistory this.getSong()
		try this.onsongchange()
		return this.getSong()

root.Song.prototype.skipTo = (songNum) ->
	return undefined if songNum >= this.playlist.length
	return undefined if songNum < 0
	
	if songNum or songNum is 0
		this.resetSongs
		this.songNumber = songNum
		
		this.updateHistory this.getSong()
		try this.onsongchange()
		
		return this.getSong()

root.Song.prototype.resetSongs = ->
	for song in this.playlist
		song.pause()
		song.currentTime = 0

root.Song.prototype.getSong = ->
	return this.playlist[this.songNumber]

root.Song.prototype.getAlbum = (audio) ->
	if not audio
		audio = this.getSong()
		
	src = audio.getAttribute 'data-img'
	img = document.createElement 'img'
	img.src = src
	
	return img

root.Song.prototype.getTitle = (audio) ->
	if not audio
		audio = this.getSong()
	
	title = audio.getAttribute 'data-title'
	return title