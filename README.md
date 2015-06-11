# song.js
<strong>Playlist Management Library</strong>

When building an HTML5 music player, you'll want some way to manage your songs. This library is a newbie's
interpretation to how it should be done.

<i>Useful APIs</i><br>
<strong>song.playlist</strong>: array of HTML nodes.<br>
<strong>song.add(objArray)</strong>: pass an object array with src, img and title properties.
This will construct the <audio> nodes and push them to the playlist.<br>
<strong>song.shuffle()</strong>: randomly re-orders the playlist.<br>
<strong>song.getSong()</strong>: retrieves the current song as an <audio> element.

<i>Less Useful APIs</i><br>
<strong>song.buildAudio(title, src, img)</strong>: pass in an object {src, title, img}
and it returns an <audio> element built to suite.<br>
<strong>song.updateIndex()</strong>: called whenever a song built with buildAudio() ends. It keeps track of the
playlist index of the current song.
