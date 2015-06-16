# song.js
<strong>Playlist Management Library</strong>

<p>
  When building an HTML5 music player, you'll want some way to manage
  your songs.
  This library is a newbie's interpretation to how it should be done.
</p>

<p>
  Call <code>var example = new Song(playlist)</code> to build a new
  playlist. The playlist you pass in should be an object array
  <code>{title, srcURL, imgURL}</code>. This will construct
  <code>&lt;audio&gt;</code> nodes and push them to the
  <code>example.playlist</code> array.<br>
  <b>Optional:</b> Use <code>example.shuffle()</code> to randomly re-order your
  playlist array.<br>
  All history is stored in the <code>example.history</code> array. Use it to
  find what song played last.
</p>

<p>
  There are many ways you could manipulate the playlist. This makes it difficult
  to say which song is playing. Since you know your implementation best, I leave
  this to you by giving you <code>example.next()</code> and
  <code>example.previous</code> methods. This will change
  the index number used to find the audio element in the playlist array.
  <code>next</code> is
  sensitive to the repeat boolean. If you choose not to use this system, nothing
  will break.<br>
  As a bonus, by using this system you can use the
  <code>example.getSong()</code> method to retrieve your current song.
</p>