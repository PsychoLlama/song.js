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