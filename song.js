(function() {
    "use strict";
    
    
    function buildAudio(title, src, img) {
        var aud = document.createElement('audio');
        
        if (title) aud.setAttribute('data-title', title);
        if (src) aud.src = src;
        if (img) aud.setAttribute('data-img', img);
        
        return aud;
    }
    
    function add(playlist) {
        if (playlist.length === 0) return;
        
        for (var i = 0; i < playlist.length; i++) {
            var audio = buildAudio(
                playlist[i].title,
                playlist[i].src,
                playlist[i].img);
            this.playlist.push(audio);
        }
        return this.playlist;
    }
    
    var Song = function(playlist) {
        this.repeat = false;
        
        this.playlist = [];
        add(playlist);
        
        this.songNumber = 0;
    };
    
    Song.prototype.history = [];
    
    
    Song.prototype.updateHistory = function(song) {
        var last = Song.prototype.history.length - 1;
        if (Song.prototype.history[last] === song) {
            return;
            // If this song was just played, don't add it to history.
        } else {
            Song.prototype.history.push(song);
        }
    };
    
    Song.prototype.shuffle = function() {
        this.songNumber = 0;
        
        // returns playlist after sort
        return this.playlist.sort(function() {
            return Math.floor(Math.random() * 3) - 1;
        });
    };
    
    Song.prototype.next = function() {
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
    
    Song.prototype.previous = function() {
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
    
    Song.prototype.resetSongs = function() {
        this.playlist.forEach(function(ele) {
            ele.pause();
            ele.currentTime = 0;
        });
    };
    
    Song.prototype.getSong = function() {
        return this.playlist[this.songNumber];
    };
});