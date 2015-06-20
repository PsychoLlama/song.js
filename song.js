(function(root) {
    'use strict';
    
    
    function buildAudio(title, src, img) {
        var aud = document.createElement('audio');
    
        if (title) aud.setAttribute('data-title', title);
        if (src) aud.src = src;
        if (img) aud.setAttribute('data-img', img);
    
        return aud;
    }
    
    function add(playlist, destination) {
        if (playlist.length === 0) return;
    
        for (var i = 0; i < playlist.length; i++) {
            var audio = buildAudio(
                playlist[i].title,
                playlist[i].src,
                playlist[i].img);
            destination.push(audio);
        }
        return destination;
    }
    
    root.Song = function(playlist) {
        this.repeat = false;
    
        this.playlist = [];
        add(playlist, this.playlist);
    
        this.songNumber = 0;
    };
    
    root.Song.prototype.history = [];
    
    
    root.Song.prototype.updateHistory = function(song) {
        var last = root.Song.prototype.history.length - 1;
        if (root.Song.prototype.history[last] === song) {
            return;
            // If this song was just played, don't add it to history.
        } else {
            root.Song.prototype.history.push(song);
        }
    };
    
    root.Song.prototype.shuffle = function() {
        this.songNumber = 0;
    
        // randomly sort playlist array
        this.playlist.sort(function() {
            return Math.floor(Math.random() * 3) - 1;
        });
        
        this.resetSongs();
        
        return this.playlist;
    };
    
    root.Song.prototype.next = function() {
        var lastSong = this.playlist.length - 1;
        var isLastSong = (this.songNumber === lastSong);
        var repeat = this.repeat;
    
        this.resetSongs();
    
        if (isLastSong && repeat) {
            this.songNumber = 0;
    
        } else if (isLastSong && !repeat) {
            return undefined;
    
        } else if (this.songNumber < lastSong) {
            this.songNumber++;
        }
    
        this.updateHistory(this.getSong());
        return this.getSong();
    };
    
    root.Song.prototype.previous = function() {
        var aud = this.getSong();
        this.resetSongs();
    
        if (aud.currentTime > 5) {
            return aud;
    
        } else if (this.songNumber === 0) {
            this.songNumber = this.playlist.length - 1;
    
        } else if (this.songNumber > 0) {
            this.songNumber--;
        }
    
        this.updateHistory(this.getSong());
        return this.getSong();
    };
    
    root.Song.prototype.resetSongs = function() {
        this.playlist.forEach(function(ele) {
            ele.pause();
            ele.currentTime = 0;
        });
    };
    
    root.Song.prototype.getSong = function() {
        return this.playlist[this.songNumber];
    };
})(this);