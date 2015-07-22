# song.js
<strong>Playlist Management Library</strong>

<p>
  When building an HTML5 music player, you'll want some way to manage
  your songs.
  This library is a newbie's interpretation to how it should be done.
</p>

<h4>
  <code>To begin:</code>
</h4>
<p>
  To make a playlist, we create a new instance:
  <code>var playlist = new Playlist('Awesome Songs')</code>.
  Our new playlist object has a lot of useful tools built in. Let's
  take a look...<br>
</p>

<h4>
  <code>playlist.add()</code>
</h4>
<p>
  How much use is a playlist without
  songs? Pass in either an <code>&lt;audio&gt;</code> node, an object
  or a whole array of objects. <code>add()</code> is pretty flexible.
<pre>{
  title: "Yellow Submarine",
  src: "path/to/submarine.mp3",
  img: "path/to/albumCover.png"
}</pre>
  Song.js automatically converts your objects into working
  <code>&lt;audio&gt;</code> elements, and pushes them to an array
  used by the built-in in tools.
</p>

<h4>
  <code>playlist.play()/pause()</code>
</h4>
<p>
  Now that you've got your playlist set up, kick it into gear
  with the <code>play()</code> method. If the awesome is too
  overwhelming, <code>pause()</code> has your back.
</p>

<h4>
  <code>playlist.next()/previous()</code>
</h4>
<p>
  <code>&lt;audio&gt;</code> elements allow for some
  nightmarish behavior. If you're using sound effects, you might
  want concurrency. But that's a horrible idea with music. Song.js
  makes sure only one song is playing at a time, and it does that
  with <code>next()</code> and <code>previous()</code>.<br>
  Both methods change the song without actually playing it,
  giving you finer control over your app.
</p>

<h4>
  <code>playlist.repeat</code>
</h4>
<p>
  After fiddling with <code>next</code> and <code>previous</code>,
  you probably noticed that <code>undefined</code> returns
  at your playlists' edges. You can break these borders by
  turning on repeat: <code>playlist.repeat = true</code>.
</p>

<h4>
  <code>playlist.shuffle()</code>
</h4>
<p>
  Get some variety with the <code>shuffle()</code> method.
  Each song gets ordered randomly in the playlist after this
  code is run.<br>
  Warning: you may want to consider a few things first...
  <ul>
    <li>Initial state will be lost.</li>
    <li>The current song will reset, and likely change
    to another.</li>
  </ul>
  These issues should be solved in a future release.
</p>

<h4>
  <code>playlist.skipTo(songNumber)</code>
</h4>
<p>
  <code>next</code> and <code>previous</code> barely touched
  your incredible thirst for power. You want more, and you'll find
  it with <code>skipTo</code>. Passing in the index of any
  song in the playlist changes your current song to your
  chosen one.
</p>

<h4>
  <code>playlist.remove(songNumber)</code>
</h4>
<p>
  The power to destroy, now in your hands. Call <code>remove</code>
  on a song index and the playlist will violently comply, even
  cleaning up the falsy values left behind.
</p>

<p>
  <strong>Uber cool tip</strong><br>
  All the methods mentioned above can be <i>chained</i>. Check it
  out:
<pre>
new Playlist("60's Mashup")
  .add(songs)
  .skipTo(3)
  .play()
  .repeat = true
</pre>
</p>

<h4>
  <code>playlist.title(song)</code>
</h4>
<p>
  Grab the title of a song. If it wasn't passed a song, it just
  grabs the current one. If you didn't define a
  title when you added the song, it will return
  <code>undefined</code>.
</p>

<h4>
  <code>playlist.album(song)</code>
</h4>
<p>
  Pretty much the same thing as <code>playlist.title()</code>,
  although it returns an <code>&lt;img&gt;</code> tag complete
  with the src you defined (you defined that, right?)
</p>
<p>
  <strong>Warning:</strong><br>
  The <code>album</code> and <code>title</code> methods may be
  implemented differently in the future.
</p>

<h4>
  <code>playlist.getSong(songNumber)</code>
</h4>
<p>
  Grabs the song at the songNumber/index passed in. It's forgiving
  and will return the current song if you didn't give it an index.
  This method is really useful for looping (more on this later).
</p>

<h4>
  <code>playlist.songChange(callback)</code>
</h4>
<p>
  <code>next</code>, <code>previous</code>, <code>skipTo</code>
  and others generate songChange events. Give songChange your
  listener function, and every time it fires we'll call it for you.
  You can register an unlimited number of listeners, and each is
  passed the current <code>&lt;audio&gt;</code> node.
</p>

<h4>
  <code>playlist.Each(callback)</code>
</h4>
<p>
  Just what it sounds like. For every song in the playlist,
  invoke the callback with that same song and it's index. Example:
<pre>
playlist.each(callback);

function callback(song, index) {
  $( '&lt;li&gt;' )
  .text( playlist.title(song) )
  .append( '#playlist' )
  .click( function() {
  
    playlist.skipTo(index);
    
  });
});
</pre>
</p>

<p>
  <strong>You made it</strong><br>
  Congrats! You've read every scrap of Song.js documentation. If
  you haven't already, give it a try and let me know what you
  think. I'd love to hear from you!
</p>

<p>
  Psssst! Hey kid! I'm looking for a web dev job...
</p>