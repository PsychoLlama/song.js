# song.js
<strong>Playlist Management Library</strong>

When building an HTML5 music player, you'll want some way to manage your songs. This library is a newbie's
interpretation to how it should be done.

<p>
Call <code>var example = new Song()</code> to build a new playlist.<br>
Next, call <code>example.add(playlist)</code> to construct the audio nodes and push them to the <code>example.playlist</code> property.<br>
The playlist you pass in should be an object array <code>{title, srcURL, imgURL}</code>.<br>
Use <code>example.shuffle()</code> to randomly re-order your playlist array.<br>
All history is stored in the <code>example.history</code> array. Use it to find what song played last.
</p>

<p>
I'm working on a way to keep track of what song is playing and return it upon request.
</p>