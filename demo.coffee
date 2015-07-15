sampleData = [
	{
		src: 'http://datashat.net/music_for_programming_1-datassette.mp3'
		img: 'album/song1.png'
		title: 'Song #1'
	}, {
		src: 'http://datashat.net/music_for_programming_2-sunjammer.mp3'
		img: 'album/song2.png'
		title: 'Song #2',
	}, {
		src: 'http://datashat.net/music_for_programming_3-datassette.mp3'
		img: 'album/song3.png'
		title: 'Song #3',
	}, {
		src: 'http://datashat.net/music_for_programming_4-com_truise.mp3'
		img: 'album/song4.png'
		title: 'Song #4'
	}
]

this.song = new Song sampleData
song.repeat = true

window.onload = ->
	(->
		nowPlaying = $ '#now-playling'

		setNowPlaying = ->
			title = $('<p>' + song.getTitle() + '</p>').append $ '<br>'

			art = $ song.getAlbum()

			nowPlaying.text ''
			nowPlaying.append title, art

		song.songChange.push setNowPlaying
		setNowPlaying()
	)()
	(->
		skipToSong = (songNum) ->
			song.skipTo songNum

		playlist = $ '#playlist'

		$(song.playlist).each (tag, index) ->
			div = $('<div>').addClass('playlist')

			h2 = $('<h2>').text( song.getTitle(tag) )

			div.append h2
			playlist.append div

			div.on 'click', ->
				skipToSong(index)
	)()
	
	$('#pause').onclick = -> song.getSong().pause()
	$('#play').onclick = -> song.getSong().play()
	$('#next').onclick = -> song.next().play()
	$('#previous').onclick = -> song.previous().play()
	$('#shuffle').onclick = -> song.shuffle()[0].play()