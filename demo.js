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

var song = new Song(sampleData);
song.repeat = true;
song.shuffle();

window.onload = function() {
    var body = document.getElementsByTagName('body')[0];
    
    body.appendChild(song.getSong());
    
    song.manage(body);
};