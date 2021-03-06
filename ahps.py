#! /usr/bin/env python

## 
## Title: ahps.py
## Author: Christopher Olsen
##               
## About: a little script to change the Audacious playlist in headless mode.
##        map a keystroke to it and now you can switch playlists while using
##        conky to display your song info!  (kinda dirty - closes audacious,
##        edits a config file then reopens audacious...)
##        

## ***uncomment this line to import the os module and take responsibility for what may
## happen as a result.  But you might want the ahps.sh file instad.***
##import os
import time

def change_config_file():
    """ Opens the audacious playlist-state file, reads it and updates it
        appropriately.
        """
    home = os.getenv('HOME')
    conf_file_path = ''.join([home, '/.config/audacious/playlist-state'])
    # make a backup by appending "~~" to the original
    os.system("cp %s %s" % (conf_file_path,
                            ''.join([conf_file_path, "~~"])))
    try:
        playlist_state_file = open(conf_file_path, 'rw+')
        file_as_list = playlist_state_file.readlines()
        num_plists = (len(file_as_list) - 2) / 4
        current_playing = int(file_as_list[1][-2])
        if current_playing == num_plists -1:
            next_plist = 0
        else:
            next_plist = current_playing + 1
        playlist_state_file.seek(0) # move to the beginning and
        playlist_state_file.truncate() # delete the rest of the file
        playlist_state_file.writelines([''.join(['active ',
                                                 str(next_plist),'\n']),
                                        ''.join(['playing ',
                                                 str(next_plist),'\n'])] +
                                       file_as_list[2:])
        playlist_state_file.close()
    except:
        # if anything goes wrong revert and act natural...we were never here
        try:
            playlist_state_file.close()
        except:
            pass
        os.system("cp %s %s" % (''.join([conf_file_path, "~~"]),
                                conf_file_path))
        
# the subprocess module may be more correct than os...
os.system("killall audacious")
change_config_file()
time.sleep(.5) # this gives the os time to shut down audacious fully before 
               # bringing it back up again. solves a bug where "audacious --fwd"
               # was bringing up a SECOND instance of audacious and advancing to
               # but not playing the next song - even though it did when asked
               # and then two instances were playing at the same time
os.system("audacious --headless --play &")
