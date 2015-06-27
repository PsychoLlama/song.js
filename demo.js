"use strict";

// This file loads in and injects sampleData for the demo website.
var sampleData = [{
    src: 'http://datashat.net/music_for_programming_1-datassette.mp3',
    img: '//raw.githubusercontent.com/PsychoLlama/song.js/master/album/song1.png',
    title: 'Song #1'
}, {
    src: 'http://datashat.net/music_for_programming_2-sunjammer.mp3',
    img: '//raw.githubusercontent.com/PsychoLlama/song.js/master/album/song2.png',
    title: 'Song #2'
}, {
    src: 'http://datashat.net/music_for_programming_3-datassette.mp3',
    img: '//raw.githubusercontent.com/PsychoLlama/song.js/master/album/song3.png',
    title: 'Song #3'
}, {
    src: 'http://datashat.net/music_for_programming_4-com_truise.mp3',
    img: '//raw.githubusercontent.com/PsychoLlama/song.js/master/album/song4.png',
    title: 'Song #4'
}];

var song = new Song(sampleData);
song.repeat = true;
song.shuffle();

song.getSong().play();

window.onload = function() {
    (function() {
        var nowPlaying = document.getElementById('now-playing');
        
        function setNowPlaying() {
            var title = document.createElement('p');
            
            title.innerHTML = song.getTitle(song.getSong()) + '<br>';
            
            var art = song.getAlbum(song.getSong());
            
            nowPlaying.innerHTML = '';
            nowPlaying.appendChild(title);
            nowPlaying.appendChild(art);
        }
        song.onsongchange = setNowPlaying;
        
        setNowPlaying();
    })();
    
    (function() {
        var select = document.getElementById('song-list');
        select.innerHTML = '';
        
        song.playlist.forEach(function(ele) {
            var option = document.createElement('option');
            option.innerHTML = ele.getAttribute('data-title');
            select.appendChild(option);
        })();
        
        select.onchange = function(e) {
            // Get songNum and skipTo(num)
        };
    })();
};