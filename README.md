This is a little script that allows one to advance to a different playlist in
Audacious while using headless mode.  I use it because I've taken to using 
conky to display my Audacious info and thus don't keep a visible instance 
running.  This is a dirty little program and I'm sure Audacious will make 
an "audtool --playlist-next" or "audtool --playback-next-playlist" option at
some point, but in the meantime...

Review the script before using it, maybe change the os module to to the 
subprocess module.


License is GNU GPLv3 which basically means do what you want but don't sell my
work.  Attribution's nice if you find it useful but really, whatever.  If it's 
useful I'm happy.


To demonstrate how it works...

Here's some sample conky code (from ~/.conkyrc):

${if_running audacious}
Current Song:
 Artist:    ${exec audtool --current-song-tuple-data artist}
 Song:	     ${exec audtool --current-song-tuple-data title}
 Album:     ${exec audtool --current-song-tuple-data album}
Audacious Controls
 Playlist: ${exec audtool --current-playlist-name}  Shuffle: ${exec audtool --playlist-shuffle-status}  Volume: ${exec audtool --get-volume}
 (C-A-8: next playlist)  (C-A-9: shuffle)
 (C-A-0: play)  (C-A-minus: prev)  (C-A-equal: next)


aaaand some Openbox keymappings (from .../openbox/rc.xml):

<!-- Audacious control buttons -->
    <keybind key="C-A-equal">
      <action name="Execute">
	<command>audacious --fwd</command>
      </action>
    </keybind>
    <keybind key="C-A-minus">
      <action name="Execute">
	<command>audacious --rew</command>
      </action>
    </keybind>
    <keybind key="C-A-0">
      <action name="Execute">
	<command>audacious --play-pause</command>
      </action>
    </keybind>
    <keybind key="C-A-9">
      <action name="Execute">
	<command>audtool --playlist-shuffle-toggle</command>
      </action>
    </keybind>
    <!-- custom audacious playlist changer button!!! -->
    <keybind key="C-A-8">
      <action name="Execute">
	<command>~/scripts/ahpsudacious_headless_playlist_switcher.py</command>
      </action>
    </keybind>