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
      var makeTag, playlist, skipToSong;
    
      makeTag = function(tag) {
        return document.createElement(tag);
      };
    
      skipToSong = function(songNum) {
        return song.skipTo(songNum);
      };
    
      playlist = document.querySelector('#playlist');
    
      song.playlist.forEach(function(tag, index) {
        var div, h1;
        div = makeTag('div');
        div.className = 'playlist';
        div.addEventListener('click', function() {
          return skipToSong(index);
        });
        h1 = makeTag('h2');
        h1.innerHTML = song.getTitle(tag);
        div.appendChild(h1);
        playlist.appendChild(div);
        return div.setAttribute('data-songIndex', index);
      });
    
    }).call(this);

};