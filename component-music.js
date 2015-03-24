var music = {
    loadHandler: function() {
        var head = document.getElementsByTagName('head')[0];

        var link = document.createElement("link");
        link.href = "component-music.css";
        link.type = "text/css";
        link.rel = "stylesheet";

        head.appendChild(link);

        music.buildFrame(head);
    },

    buildFrame: function(head) {
        // Create the frame to hold all music data
        // PLEASE! Future me, make this smaller and less horrible looking.
        this.container = document.createElement('div');
        this.container.setAttribute('class', 'music container');

        this.albumArt = document.createElement('img');
        this.albumArt.setAttribute('class', 'music album-art');
        this.albumArt.setAttribute('src', 'art/temp.jpg');
        this.container.appendChild(this.albumArt);

        this.playlist = document.createElement('div');
        this.playlist.setAttribute('class', 'music panel playlist noselect');
        this.container.appendChild(this.playlist);

        this.progress = document.createElement('hr');
        this.progress.setAttribute('class', 'music panel');
        this.container.appendChild(this.progress);

        this.panel = document.createElement('div');
        this.panel.setAttribute('class', 'music panel controls noselect');
        this.container.appendChild(this.panel);

        this.backButton = document.createElement('span');
        this.backButton.setAttribute('class', 'fa fa-fast-backward');
        this.panel.appendChild(this.backButton);

        this.play = document.createElement('span');
        this.play.setAttribute('class', 'fa fa-play');
        this.panel.appendChild(this.play);

        this.nextButton = document.createElement('span');
        this.nextButton.setAttribute('class', 'fa fa-fast-forward');
        this.panel.appendChild(this.nextButton);

        var body = document.getElementsByTagName('body')[0];
        body.appendChild(this.container);

        this.loadPlaylists();
    },

    loadPlaylists: function() {
        // Playlists is an object array, with title and source properties
        try {
            for (var i = 0; i < musicPlaylists.length; i++) {
                var playlistItem = document.createElement('h1');
                playlistItem.setAttribute('class', 'music playlist-item');
                playlistItem.setAttribute('data-src', musicPlaylists[i].src);
                playlistItem.innerHTML = musicPlaylists[i].title;
                playlistItem.addEventListener('click', this.requestSongs);

                music.playlist.appendChild(playlistItem);
            }
        } catch (e) {
            console.log('No playlists found. Please declare the musicPlaylists object array before\n' +
                'the HTML music-component.js script declaration. Format follows:\n\n' +
                'musicPlaylists = [\n' +
                    '  {\n' +
                        '    title: "Your Playlist Title",\n' +
                        '    src: "URL to your playlist"\n' +
                    '  },\n' +
                    '  {\n' +
                        '    title: "Another Playlist",\n' +
                        '    src: "You get the gist"\n' +
                    '  }\n' +
                '];');
        }
    },

    requestSongs: function(e) {
        music.playlist.outerHTML = '';
        var url = e.target.getAttribute('data-src');

        var request = new XMLHttpRequest();
        request.open('GET', url);
        request.addEventListener('load', function(e) {
            if (request.status === 200) {
                music.loadSongs(request.response);
            } else {
                throw new Error('Error loading playlist source. Check the url, and try again.');
            }
        });
        request.send(null);
    },

    loadSongs: function(response) {
        if (response.match(/^\s*\[(\{\s*src:\s*[\'\"].+?[\'\"],\s*img:\s*[\'\"].+?[\'\"],\s*title:\s*[\'\"].+?[\'\"]\s*},?\s*)*\s*\];?\s*$/)) {
            // Not going to kill us all. Proceed.
            var playlistData = eval(response);

            this.songList = [];

            // FUTURE SHUFFLE FUNCTION HERE

            for (var i = 0; i < playlistData.length; i++) {
                var audio = document.createElement('audio');
                audio.setAttribute('src', playlistData[i].src);
                audio.setAttribute('data-img', playlistData[i].img);
                audio.setAttribute('data-title', playlistData[i].title);

                audio.onended = this.nextSong;
                audio.ontimeupdate = this.updateProgress;

                this.songList.push(audio);

                this.container.appendChild(audio);
            }

            this.songList.currentSong = 0;
            this.updateArtwork(this.songList[this.songList.currentSong]);

            this.bindControls();
        } else {
            throw new Error('For security reasons, we cannot parse your playlist file. Please check your syntax, and try again.' +
                '\nDeclare an object array. Each object should hold a src: to a song file, ' +
                'an img: source, and a song title: property. Whitespace does not matter.');
        }
    },

    bindControls: function() {
        this.play.addEventListener('click', this.togglePlay);
        this.nextButton.addEventListener('click', this.nextSong);
        this.backButton.addEventListener('click', this.previousSong);
    },

    togglePlay: function(e) {
        // Careful! 'this' refers to the event.target now.
        if (e.target.className.match(/play/g)) {
            // User has asked to play song
            music.playSong();

            e.target.className = e.target.className.replace(/play/g, 'pause');
        } else {
            music.pauseSong();
            e.target.className = e.target.className.replace(/pause/g, 'play');
        }
    },

    playSong: function() {
        if (music.songList.currentSong === (music.songList.length - 1) && music.songList[music.songList.currentSong].ended === true) {
            // The last song has ended, and play has been requested

            // FUTURE SHUFFLE FUNCTION HERE
            this.songList.currentSong = 0;
        }
        music.play.className = music.play.className.replace(/play/g, 'pause');
        this.songList[this.songList.currentSong].play();
    },

    pauseSong: function() {
        this.songList[this.songList.currentSong].pause();
    },

    updateArtwork: function(node) {
        this.albumArt.src = node.getAttribute('data-img');
    },

    updateProgress: function() {
        // 'this' is now refers to the event
        var percent = (this.currentTime / this.duration) * 100;
        music.progress.style.width = percent + '%';
    },

    nextSong: function() {
        music.pauseAllSongs();
        if (music.songList.currentSong === music.songList.length -1 && music.repeat) {
            // We're on the last song, and repeat is on.
            music.pauseSong();
            music.songList.currentSong = 0;
            music.playSong();
        } else if (music.songList.currentSong === music.songList.length -1 && music.repeat === false) {
            // Last song, repeat is off.
            return;
        } else {
            music.songList.currentSong++;
            music.playSong();
        }
        music.updateArtwork(music.songList[music.songList.currentSong]);
    },

    previousSong: function() {
        music.pauseAllSongs();
        if (music.songList[music.songList.currentSong].currentTime > 5) {
            music.songList[music.songList.currentSong].currentTime = 0;
        } else if (music.songList.currentSong === 0) {
            music.songList.currentSong = music.songList.length - 1;
            music.playSong();
        } else {
            music.songList.currentSong--;
            music.playSong();
        }
        music.updateArtwork(music.songList[music.songList.currentSong]);
    },

    pauseAllSongs: function() {
        var allSongs = document.querySelectorAll('audio');
        for (var i = 0; i < allSongs.length; i++) {
            allSongs[i].pause();
        }
    },

    repeat: true
}

// Handle script injection, post load
if (document.readyState === 'complete') {
    music.loadHandler();
}
window.addEventListener('load', music.loadHandler);