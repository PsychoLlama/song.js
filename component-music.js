var music = {
    loadHandler: function() {
        var head = document.getElementsByTagName('head')[0];

        var link = document.createElement("link");
        link.href = "component-music.css";
        link.type = "text/css";
        link.rel = "stylesheet";

        head.appendChild(link);

        music.buildFrame(head);

        var play = document.getElementsByClassName('fa-play')[0];
        play.addEventListener('click', togglePlay);

        function togglePlay() {
            if (play.className.match(/play/g)) {
                play.className = play.className.replace(/play/g, 'pause');
            } else {
                play.className = play.className.replace(/pause/g, 'play');
            }
        }
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
        var url = e.target.getAttribute('data-src');

        var request = new XMLHttpRequest();
        request.open('GET', url);
        request.addEventListener('load', function(e) {
            if (request.status === 200) {
                music.loadSongs(this.response);
            } else {
                throw new Error('Error loading playlist source. Check the url, and try again.');
            }
        });
        request.send(null);
    },
    loadSongs: function(response) {
        if (response.match(/^\s*\[(\{\s*src:\s*[\'\"].+?[\'\"],\s*img:\s*[\'\"].+?[\'\"],\s*title:\s*[\'\"].+?[\'\"]\s*},?\s*)*\s*\];?\s*$/)) {
            // Not going to kill us all. Proceed.
            this.songList = eval(response);
            console.log(this.songList);

            for (var i = 0; i < this.songList.length; i++) {
                var audio = document.createElement('audio');
                audio.setAttribute('src', this.songList[i].src);
                this.container.appendChild(audio);
            }


        } else {
            throw new Error('For security reasons, we cannot parse your playlist file. Please check your syntax, and try again.' +
                '\nDeclare an object array. Each object should hold a src: to a song file, '+
                'an img: source, and a song title: property. Whitespace does not matter.');
        }
    }
}
// Handle script injection, post load
if (document.readyState === 'complete') {
    music.loadHandler();
}
window.addEventListener('load', music.loadHandler);