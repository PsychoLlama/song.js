"use strict";

// This file loads in and injects sampleData for the demo website.
var sampleData = [{
    src: '//datashat.net/music_for_programming_1-datassette.mp3',
    img: 'album/song1.png',
    title: 'Song #1'
}, {
    src: '//datashat.net/music_for_programming_2-sunjammer.mp3',
    img: 'album/song2.png',
    title: 'Song #2'
}, {
    src: '//datashat.net/music_for_programming_3-datassette.mp3',
    img: 'album/song3.png',
    title: 'Song #3'
}, {
    src: '//datashat.net/music_for_programming_4-com_truise.mp3',
    img: 'album/song4.png',
    title: 'Song #4'
}];

var song = new Song();
song.add(sampleData);
song.repeat = true;
song.shuffle();

window.onload = function() {
    var body = document.getElementsByTagName('body')[0];

    // Add controls to all <audio>
    // Replace ended songs with the next one
    for (var i = 0; i < song.playlist.length; i++) {
        song.playlist[i].controls = true;
        
        song.playlist[i].addEventListener('ended', function() {
            var oldSong = song.getSong();
            body.replaceChild(song.next(), oldSong);
        });
    }
    
    body.appendChild(song.getSong());
};