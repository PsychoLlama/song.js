"use strict";

// This file loads in and injects sampleData for the demo website.
var sampleData = [{
    src: 'http://datashat.net/music_for_programming_1-datassette.mp3',
    img: 'album/song1.png',
    title: 'Song #1'
}, {
    src: 'http://datashat.net/music_for_programming_2-sunjammer.mp3',
    img: 'album/song2.png',
    title: 'Song #2'
}, {
    src: 'http://datashat.net/music_for_programming_3-datassette.mp3',
    img: 'album/song3.png',
    title: 'Song #3'
}, {
    src: 'http://datashat.net/music_for_programming_4-com_truise.mp3',
    img: 'album/song4.png',
    title: 'Song #4'
}];

var song = new Song(sampleData);
song.repeat = true;
song.shuffle();

song.getSong().play();

(function() {
    var nowPlaying = document.getElementById('now-playing');
    
    song.onsongchange = function() {
        var title = document.createElement('p');
        
        title.innerHTML = song.getTitle(song.getSong()) + '<br>';
        
        var art = song.getAlbum(song.getSong());
        
        nowPlaying.innerHTML = art + title;
    };
});