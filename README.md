# song.js
<strong>Playlist Management Library</strong>

<p>
  When building an HTML5 music player, you'll want some way to manage
  your songs.
  This library is a newbie's interpretation to how it should be done.
</p>

<p>
  To begin, we start with an object array. This contains all songs we want
  inside the playlist. Each song object should hold a title, src and img src
  string.<br>
  <code><pre>
    var playlist = [{
    
      title: 'Song Title',
      src: 'URLtoSong',
      img: 'URLtoImage'
    }, {
    
      title: 'Second Song',
      src: 'URLtoSong',
      img: 'URLtoImage'
    }];
  </pre></code>
  <br>
  We then give that to the playlist manager by calling
  <code>var playlistMgr = new Song(playlist)</code>. This returns an object
  with management tools built in.
</p>

<p>
  
</p>