'use strict'
try
	new Audio()
catch
	return @Playlist = undefined

Callback = `(function(){var t,n,i=[].slice;return n={},t=function(){function t(t){if(null==t&&(t=null),null===t&&(t=function(){}),t.constructor!==Function)throw new Error("That ain't no function, missy");this.callback=t,this.fired=[],this.cancelled=!1,this["this"]=null,this.pass=null,this.conditional=null,this.error=null}return t.prototype.config=function(t){var n;if("object"!=typeof t)return!1;for(n in t)this.hasOwnProperty(n)&&(this[n]=t[n]);return this},t.prototype.cancel=function(n,i){return null==n&&(n=null),null==i&&(i=null),null===n?this.cancelled=!0:new t(function(t){return function(){return t.cancelled=!0}}(this)).when(n,i),this},t.prototype.renew=function(n,i){return null==n&&(n=null),null==i&&(i=null),null===n?this.cancelled=!1:new t(function(t){return function(){return t.cancelled=!1}}(this)).when(n,i),this},t.prototype["catch"]=function(t){return t?(this.error=t,this):void 0},t.prototype.when=function(t,i){var e,r;if(t){switch(t.constructor){case String:n[t]||(n[t]=new Array),n[t].push(this);break;case Number:r=t,e=i,e?setInterval(function(t){return function(){return t.invoke()}}(this),r):setTimeout(function(t){return function(){return t.invoke()}}(this),r);break;default:try{i=i.toLowerCase()}catch(l){}if("load"===i)switch(t.readyState){case"complete":case 4:this.invoke(t)}"function"==typeof t.addEventListener&&t.addEventListener(i,function(t){return function(n){return t.invoke(n)}}(this))}return this}},t.prototype["if"]=function(t){return"function"!=typeof t?!1:(this.conditional=t,this)},t.prototype.invoke=function(t){var n,i;if(null==t&&(t=null),this.cancelled)return!1;if(this.conditional&&(n=this.conditional(),!n))return n;try{null!=this["this"]&&null!=this.pass?this.callback.call(this["this"],this.pass):null!=this["this"]&&null!=t?this.callback.call(this["this"],t):null==this["this"]||t?null!=this.pass?this.callback(this.pass):null!=t?this.callback(t):this.callback():this.callback.call(this["this"]),this.fired.push(new Date)}catch(e){if(i=e,!this.error)throw i;this.error(i)}return this},t}(),t.fire=function(){var t,e,r,l,s,c;if(r=arguments[0],t=2<=arguments.length?i.call(arguments,1):[],"string"==typeof r&&n[r]){for(c=n[r],l=0,s=c.length;s>l;l++){e=c[l];try{t.length?e.invoke(t):e.invoke()}catch(u){}}return n[r]}},t}).call(this)`

root = @

fetched = {}

# Generic methods
fetch = (url) ->
	if fetched[url]
		@add fetched[url]
	else
		request = new XMLHttpRequest()
		request.open 'get', url, true
		
		new Callback =>
			songs = JSON.parse request.responseText
			fetched[url] = songs
			
			@add songs
		.when request, 'load'
		
		request.send()
		@songRequest = request
	
	return @

dismantle = (array) ->
	for object in array
		@add object
	
	return @

Song = (song) ->
	audio = new Audio()
	if song.src then audio.src = song.src
	if song.title
		audio.setAttribute 'data-title', song.title
	if song.img
		audio.setAttribute 'data-img', song.img
	
	new Callback =>
		@event.fire 'playing', !audio.paused
	.when audio, 'playing'
	.when audio, 'pause'
	
	new Callback =>
		resetSongs @, audio
	.when audio, 'playing'
	
	return audio

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
		
		@songRequest = {}
		@songRequest.readyState = 'complete'
		
		@songs = []
		@repeatState = false
		
		@songNumber = 0
		@event =
			fire: (type, arg) ->
				return if @hasOwnProperty type is false
				return if @[type].constructor isnt Array
				
				for callback in @[type]
					try
						if arg is undefined
							callback @
						else callback arg
			song: []
			playlist: []
			playing: []
	
	
	# Inherited methods
	onChange: (type, callback) =>
		type = type.toLowerCase()
		
		return null if type of @event is false
		@event[type].push callback
		
		return @
	
	repeat: (bool=null) ->
		if bool is null then return @repeatState
		
		if typeof bool is 'boolean'
			@repeatState = bool
		
		return @

	shuffle: ->
		lastSong = @getSong()
		
		@songNumber = 0
		resetSongs(@)
	
		@songs.sort ->
			(Math.floor Math.random() * 3) - 1
		
		if lastSong isnt @getSong()
			@event.fire 'song', @
		@event.fire 'playlist', @
		
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
			currentTime = 0
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
		
		@event.fire 'song', @
		
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
				return fetch.call @, data
			when Array
				return dismantle.call @, data
			when Object
				return @add Song.call @, data
		
		return if data.tagName isnt 'AUDIO'
		
		@songs.push data
		@event.fire 'playlist', @
		
		return @
	
	remove: (songNum) ->
		if 0 <= songNum < @songs.length
			
			try @songs[songNum].pause()
			delete @songs[songNum]
			@songs = clean(@songs)
			@event.fire 'playlist', @
			
			if @songNumber is songNum
				@songNumber = 0
				@event.fire 'song', @
			else if @songNumber > songNum
				@songNumber--
			
			return @
	
	# Only used internally:
	# If you need to use "this" in an after callback,
	# use a fat arrow function.
	after: (callback) ->
		new Callback =>
			callback @
		.when @songRequest, 'load'
		
		return @
	
	each: (callback) ->
		for song in @songs
			try callback(song, _i)
		
		return @
	
	clear: -> @after => @each => @remove 0

root.Playlist = Playlist