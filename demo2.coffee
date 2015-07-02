sampleData = [
	{
		src: 'http://datashat.net/music_for_programming_1-datassette.mp3'
		img: '//raw.githubusercontent.com/PsychoLlama/song.js/master/album/song1.png'
		title: 'Song #1'
	}, {
		src: 'http://datashat.net/music_for_programming_2-sunjammer.mp3'
		img: '//raw.githubusercontent.com/PsychoLlama/song.js/master/album/song2.png'
		title: 'Song #2',
	}, {
		src: 'http://datashat.net/music_for_programming_3-datassette.mp3'
		img: '//raw.githubusercontent.com/PsychoLlama/song.js/master/album/song3.png'
		title: 'Song #3',
	}, {
		src: 'http://datashat.net/music_for_programming_4-com_truise.mp3'
		img: '//raw.githubusercontent.com/PsychoLlama/song.js/master/album/song4.png'
		title: 'Song #4'
	}
]

song = new Song sampleData
song.repeat = true
song.shuffle()

window.onload = ->
	makeTag = (tag) -> document.createElement(tag)
	(->
		nowPlaying = document.getElementById 'now-playing'

		setNowPlaying = ->
			title = makeTag 'p'
			title.innerHTML = song.getTitle(song.getSong()) + '<br>'

			art = song.getAlbum(song.getSong())

			nowPlaying.innerHTML = ''
			nowPlaying.appendChild title
			nowPlaying.appendChild art

		song.onsongchange = setNowPlaying
		setNowPlaying()
		)()
	(->
		skipToSong = (songNum) ->
			song.skipTo songNum

		playlist = document.getElementById 'playlist'

		song.playlist.forEach (tag, index) ->
			div = makeTag 'div'
			div.className = 'playlist'

			h2 = makeTag 'h2'
			h2.innerHTML = song.getTitle(tag)

			div.appendChild h2
			playlist.appendChild div

			div.addEventListener 'click', ->
				skipToSong(index)
		)()