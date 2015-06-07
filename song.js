var song = {
    repeat: false,
    playlist: [],
    currentIndex: 0,
    
    add: function(playlist) {
        if (playlist.length === 0) return;
        
        for (var i = 0; i < playlist.length; i++) {
            var audio = song.buildAudio(
                playlist[i].title,
                playlist[i].src,
                playlist[i].img);
            song.playlist.push(audio);
        }
        return song.playlist;
    },
    buildAudio: function(title, src, img) {
        var aud = document.createElement('audio');
        
        if (title) aud.setAttribute('data-title', title);
        if (src) aud.src = src;
        if (img) aud.setAttribute('data-img', img);
        
        aud.addEventListener('ended', song.updateIndex);
        
        return aud;
    },
    updateIndex: function() {
        if (song.currentIndex === song.playlist.length - 1) {
            if (song.repeat) {
                song.currentIndex = 0;
            }
        } else song.currentIndex++;
    },
    
    getSong: function() {
        return song.playlist[song.currentIndex];
    },
    shuffle: function() {
        // returns playlist after sort
        return song.playlist.sort(function() {
            return Math.floor(Math.random() * 3) - 1;
        });
    }
};

var sampleData = [{
    src: '//datashat.net/music_for_programming_1-datassette.mp3',
    img: 'art/song1.png',
    title: 'Song #1'
}, {
    src: '//datashat.net/music_for_programming_2-sunjammer.mp3',
    img: 'art/song2.png',
    title: 'Song #2'
}, {
    src: '//datashat.net/music_for_programming_3-datassette.mp3',
    img: 'art/song3.png',
    title: 'Song #3'
}, {
    src: '//datashat.net/music_for_programming_4-com_truise.mp3',
    img: 'art/song4.png',
    title: 'Song #4'
}];
song.add(sampleData);