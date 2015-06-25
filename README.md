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
  string.
  <pre>var playlist = [{

  title: 'Song Title',
  src: 'URLtoSong',
  img: 'URLtoImage'
}, {

  title: 'Second Song',
  src: 'URLtoSong',
  img: 'URLtoImage'
}];</pre>
  We then give that to the playlist manager by calling
  <code>var playlistMgr = new Song(playlist)</code>. This returns an object
  with management tools built in.
</p>

<p>
  When we passed <code>playlist</code> into the Song constructor, it
  automatically built audio elements out of our playlist array. Our manager
  keeps them in the <code>playlistMgr.playlist</code> array. Unless you need
  to pull elements into the DOM (which is <i>not</i> required to play them),
  you should not need to touch this list. It is there for convenience only.<br>
  To grab the current song, use <code>playlistMgr.getSong()</code> and it will
  return the &lt;audio&gt; element. To move between songs, use
  <code>playlistMgr.next()</code> and <code>playlistMgr.previous()</code>.
  These methods return the current song after their operation.<br>
  You may set the <code>playlistMgr.repeat</code> boolean to suit your needs.
</p>

<p>
  Included in the manager is a <code>playlistMgr.shuffle()</code> method,
  which randomly reorganizes the <code>playlistMgr.playlist</code> array.
  It returns the shuffled array.<br>
  Also included is the <code>playlistMgr.history</code> array, which holds
  memory of every song played through the library. It is important to note
  that even if you have seperate playlists, they all push to the same history
  array.
</p>

<p>
  Some features are still in development, such as:
  <ul>
    <li>
      <code>playlistMgr.onsongchange</code>, which allows the user access to a
      song change event.
    </li>
    
    <li>
      <code>playlistMgr.getAlbum(audioElem)</code>, which builds an 
      <code>&lt;img&gt;</code> element and returns it using the source provided
      in the inital song object. If no <code>&lt;audio&gt;</code> element is
      passed, <code>getSong()</code> is used.
    </li>
    
    <li>
      <code>playlistMgr.getTitle(audioElem)</code>, which returns the title
      string used in the inital song object. Once again, if no element is
      passed, <code>getSong()</code> is used.
    </li>
  </ul>
</p>

<p>
  Well, that should get you started! Feel free to ask if you have questions,
  and pull requests are always welcome!
</p>
<p>Have fun out there!!</p>