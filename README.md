# song.js
<strong>Playlist Management Library</strong>

<p>
  When building an HTML5 music player, you'll want some way to manage
  your songs.
  This library is a newbie's interpretation to how it should be done.
</p>

<small style='font-size: 70%;'>
  Song.js is a non-concurrent &lt;audio&gt; abstraction layer
  designed to remove complexity from building playlists,
  such as song tracking, data
  association, high-level event generation, song navigation, and
  AJAX imports.<br>
  <br>
  Song.js meant for music, podcasts and similar media,
  <em>not</em> sound effects. If that's what you're looking for,
  check out
  <a href="//github.com/goldfire/howler.js">Howler.js</a>.
</small>

<h4>To begin:</h4>
<p>
  To make a playlist, we create a new instance:
  <code>var playlist = new Playlist('Awesome Songs')</code>.
  Our new playlist object has a lot of useful tools built in. Let's
  take a look...<br>
</p>

<h4>playlist.add()</h4>
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

<h4>playlist.play()/pause()</h4>
<p>
  Now that you've got your playlist set up, kick it into gear
  with the <code>play()</code> method. If the awesome is too
  overwhelming, <code>pause()</code> has your back.
</p>

<h4>playlist.next()/previous()</h4>
<p>
  <code>&lt;audio&gt;</code> elements allow for some
  nightmarish behavior. If you're using sound effects, you might
  want concurrency. But that's a horrible idea with music. Song.js
  makes sure only one song is playing at a time, and it does that
  with <code>next()</code> and <code>previous()</code>.<br>
  Both methods change the song without actually playing it,
  giving you finer control over your app.
</p>

<h4>playlist.repeat(boolean)</h4>
<p>
  After fiddling with <code>next</code> and <code>previous</code>,
  you probably noticed that <code>undefined</code> returns
  at your playlists' edges. You can break these borders by
  turning on repeat: <code>repeat(true)</code>.
  To see what it's set at, just ask <code>repeat()</code>.
</p>

<h4>playlist.shuffle()</h4>
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

<h4>playlist.skipTo(songNumber)</h4>
<p>
  <code>next</code> and <code>previous</code> barely touched
  your incredible thirst for power. You want more, and you'll find
  it with <code>skipTo</code>. Passing in the index of any
  song in the playlist changes your current song to your
  chosen one.
</p>

<h4>playlist.remove(songNumber)</h4>
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
  .repeat(true)
  .skipTo(3)
  .play()
</pre>
</p>

<h4>playlist.title(song)</h4>
<p>
  Grab the title of a song. If it wasn't passed a song, it just
  grabs the current one. If you didn't define a
  title when you added the song, it will return
  <code>undefined</code>.
</p>

<h4>playlist.album(song)</h4>
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

<h4>playlist.getSong(songNumber)</h4>
<p>
  Grabs the song at the songNumber/index passed in. It's forgiving
  and will return the current song if you didn't give it an index.
  This method is really useful for looping (more on this later).
</p>

<h4>playlist.onChange(type, callback)</h4>
<p>
  <code>next</code>, <code>previous</code>, <code>skipTo</code>
  and others generate onChange events. Call onChange with the
  type of change you want to listen for, such as
  <code>playlist</code> or <code>song</code>, and we'll let
  you know when that information changes. Just give us a
  callback:
<pre>playlist.onChange("song",
  function(song) {
    // Update song
  });</pre>
  Any time the current song is changed,
  all of your callbacks for that event are invoked.
  You can register an unlimited number of listeners, and each is
  passed the current <code>&lt;audio&gt;</code> node.
</p>

<h4>playlist.Each(callback)</h4>
<p>
  Just what it sounds like. For every song in the playlist,
  invoke the callback with that same song and it's index. Example:
<pre>playlist.each(callback);

function callback(song, index) {
  $( '&lt;li&gt;' )
  .text( playlist.title(song) )
  .append( '#playlist' )
  .click( function() {
  
    playlist.skipTo(index);
    
  });
});</pre>
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