var song = {
    createAudioElem: function(src, title, img) {
        var aud = document.createElement('audio');
        
        if (src) aud.setAttribute('src', src);
        if (title) aud.setAttribute('data-title', title);
        if (img) aud.setAttribute('data-img', img);
        
        return aud;
    }
};
song.createAudioElem('//datashat.net/music_for_programming_4-com_truise.mp3');