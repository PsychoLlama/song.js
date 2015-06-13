var Song = function() {
    this.repeat = false;
    this.playlist = [];
    this.songNumber = 0;
};

Song.prototype.history = [];

Song.prototype.add = function(playlist) {
    if (playlist.length === 0) return;
    
    for (var i = 0; i < playlist.length; i++) {
        var audio = this.buildAudio(
            playlist[i].title,
            playlist[i].src,
            playlist[i].img);
        this.playlist.push(audio);
    }
    return this.playlist;
};

Song.prototype.buildAudio = function(title, src, img) {
    var aud = document.createElement('audio');
    
    if (title) aud.setAttribute('data-title', title);
    if (src) aud.src = src;
    if (img) aud.setAttribute('data-img', img);
    
    aud.addEventListener('ended', this.updateHistory);
    
    return aud;
};

Song.prototype.updateHistory= function(e) {
    var last = this.history.length - 1;
    if (this.history[last] === e.target) {
        return;
        // If this song was just played, don't add it to history.
    } else {
        this.history.push(e.target);
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
    var last = this.playlist.length - 1;
    
    // This block is pretty complex.
    // It checks whether the song is the last one in the playlist
    //    and if repeat is on.
    // It will return the current song or undefined.
    if (this.songNumber === last && this.repeat) {
        this.songNumber = 0;
        return this.getSong();
    } else if (this.songNumber === last && this.repeat === false) {
        return undefined;
    } else if (this.songNumber < last) {
        this.songNumber++;
        return this.getSong();
    } else return undefined;
};

Song.prototype.previous = function() {
    var aud = this.getSong();
    
    if (aud.currentTime > 5) {
        aud.currentTime = 0;
        return aud;
    } else if (this.songNumber === 0) {
        this.songNumber = this.playlist.length - 1;
        return this.getSong();
    } else {
        this.songNumber--;
        return this.getSong();
    }
};

Song.prototype.getSong = function() {
    return this.playlist[this.songNumber];
};