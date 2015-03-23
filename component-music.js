var music = {
    init: function(head) {
        var container = document.createElement('div');
        container.setAttribute('class', 'music container');

        var albumArt = document.createElement('img');
        albumArt.setAttribute('class', 'music album-art');
        albumArt.setAttribute('src', 'art/temp.jpg');
        container.appendChild(albumArt);

        var playlist = document.createElement('div');
        playlist.setAttribute('class', 'music panel playlist noselect');
        container.appendChild(playlist);

        for (var i = 0; i < 10; i++) {
            var pianoGuys = document.createElement('h1');
            pianoGuys.setAttribute('class', 'music playlist-item');
            pianoGuys.innerHTML = 'The Piano Guys';
            playlist.appendChild(pianoGuys);
        }

        var panel = document.createElement('div');
        panel.setAttribute('class', 'music panel controls noselect');
        container.appendChild(panel);

        var backButton = document.createElement('span');
        backButton.setAttribute('class', 'fa fa-fast-backward');
        panel.appendChild(backButton);

        var play = document.createElement('span');
        play.setAttribute('class', 'fa fa-play');
        panel.appendChild(play);

        var nextButton = document.createElement('span');
        nextButton.setAttribute('class', 'fa fa-fast-forward');
        panel.appendChild(nextButton);

        var body = document.getElementsByTagName('body')[0];
        body.appendChild(container);
    }
}
window.addEventListener('load', function() {
    var head = document.getElementsByTagName('head')[0];

    var link = document.createElement("link");
    link.href = "component-music.css";
    link.type = "text/css";
    link.rel = "stylesheet";

    head.appendChild(link);

    music.init(head);

    var play = document.getElementsByClassName('fa-play')[0];
    play.addEventListener('click', togglePlay);

    function togglePlay() {
        if (play.className.match(/play/g)) {
            play.className = play.className.replace(/play/g, 'pause');
        } else {
            play.className = play.className.replace(/pause/g, 'play');
        }
    }
});