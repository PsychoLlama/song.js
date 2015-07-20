// Generated by CoffeeScript 1.7.1
(function() {
  'use strict';
  var clean, fireSongEvent, makeAudio, resetSongs, root;

  root = this;

  makeAudio = function(song) {
    var audio;
    audio = new Audio();
    if (song.src) {
      audio.src = song.src;
    }
    if (song.title) {
      audio.setAttribute('data-title', song.title);
    }
    if (song.img) {
      audio.setAttribute('data-img', song.img);
    }
    return audio;
  };

  fireSongEvent = function(instance) {
    var callback, _i, _len, _ref, _results;
    try {
      _ref = instance.callbacks;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        callback = _ref[_i];
        _results.push(callback(instance.getSong()));
      }
      return _results;
    } catch (_error) {}
  };

  clean = function(array) {
    var value, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      value = array[_i];
      if (value) {
        _results.push(value);
      }
    }
    return _results;
  };

  resetSongs = function(instance) {
    var playlist, song, _i, _len;
    playlist = instance.playlist;
    for (_i = 0, _len = playlist.length; _i < _len; _i++) {
      song = playlist[_i];
      try {
        song.pause();
        song.currentTime = 0;
      } catch (_error) {}
    }
    return instance;
  };

  root.Song = function(playlist) {
    this.repeat = false;
    this.playlist = [];
    this.add(playlist);
    this.songNumber = 0;
    this.callbacks = [];
    return this;
  };

  root.Song.prototype = {
    constructor: root.Song,
    songChange: function(callback) {
      this.callbacks.push(callback);
      return this;
    },
    shuffle: function() {
      this.songNumber = 0;
      this.playlist.sort(function() {
        return (Math.floor(Math.random() * 3)) - 1;
      });
      resetSongs(this);
      fireSongEvent(this);
      return this;
    },
    play: function() {
      var song;
      song = this.getSong();
      if (song) {
        song.play();
        return this;
      }
    },
    pause: function() {
      var song;
      song = this.getSong();
      if (song) {
        song.pause();
        return this;
      }
    },
    next: function() {
      var isLastSong, lastSong, repeat;
      lastSong = this.playlist.length - 1;
      isLastSong = this.songNumber === lastSong;
      repeat = this.repeat;
      if (isLastSong && repeat) {
        return this.skipTo(0);
      } else if (isLastSong && !repeat) {
        return void 0;
      } else if (this.songNumber < lastSong) {
        return this.skipTo(this.songNumber + 1);
      }
    },
    previous: function() {
      var audio;
      audio = this.getSong();
      if (audio.currentTime < 5 && audio.currentTime > 0) {
        resetSongs(this);
        return this;
      } else if (this.songNumber === 0 && this.repeat) {
        return this.skipTo(this.playlist.length - 1);
      } else if (this.songNumber > 0) {
        return this.skipTo(this.songNumber - 1);
      }
    },
    skipTo: function(songNum) {
      if (songNum >= this.playlist.length) {
        return void 0;
      }
      if (songNum < 0) {
        return void 0;
      }
      if (songNum || songNum === 0) {
        resetSongs(this);
        this.songNumber = songNum;
        fireSongEvent(this);
        return this;
      }
    },
    getSong: function(songNum) {
      if (!songNum) {
        return this.playlist[this.songNumber];
      }
      if (songNum >= 0 && songNum < this.playlist.length) {
        return this.playlist[songNum];
      }
    },
    album: function(audio) {
      var img, src;
      if (audio == null) {
        audio = this.getSong();
      }
      src = audio.getAttribute('data-img');
      if (src === null) {
        return;
      }
      img = document.createElement('img');
      img.src = src;
      return img;
    },
    title: function(audio) {
      var songTitle;
      if (audio == null) {
        audio = this.getSong();
      }
      try {
        songTitle = audio.getAttribute('data-title');
      } catch (_error) {
        songTitle = '';
      }
      return songTitle;
    },
    add: function(data) {
      var song, _i, _len;
      if (typeof data !== 'object') {
        return null;
      }
      if (data.length > 0) {
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          song = data[_i];
          this.playlist.push(makeAudio(song));
        }
      } else if (data.tagName === 'AUDIO') {
        this.playlist.push(data);
      } else {
        this.playlist.push(makeAudio(data));
      }
      fireSongEvent(this);
      return this;
    },
    remove: function(songNum) {
      if (songNum >= 0 && songNum < this.playlist.length) {
        delete this.playlist[songNum];
        this.playlist = clean(this.playlist);
        fireSongEvent(this);
        if (this.songNumber === songNum) {
          this.songNumber = 0;
        } else if (this.songNumber > songNum) {
          this.songNumber--;
        }
        return this;
      }
    },
    each: function(callback) {
      var song, _i, _len, _ref;
      try {
        _ref = this.playlist;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          song = _ref[_i];
          callback(song);
        }
      } catch (_error) {}
      return this;
    }
  };

}).call(this);
