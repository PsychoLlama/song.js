var Song = function() {
    this.repeat = false;
    this.playlist = [];
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
    // returns playlist after sort
    return this.playlist.sort(function() {
        return Math.floor(Math.random() * 3) - 1;
    });
};