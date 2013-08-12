#!/bin/bash

## Title: ahps.sh
## Author: Christopher Olsen
## Copyright 2013 Christopher Olsen
## License: GPLv3, GNU General Public License Version 3
##
## About: a little script to change the Audacious playlist in headless mode.
##        map a keystroke to it and now you can switch playlists while using
##        conky to display your song info!  (kinda dirty - closes audacious,
##        edits a config file then reopens audacious...)

## this currently runs dirty, if it fails the backup will have to be 
## restored manually.  (It's my first bash script)

killall audacious

REL_CONF_PATH='/.config/audacious/playlist-state'
ABS_CONF_PATH=$HOME$REL_CONF_PATH

# create a backup
cp $ABS_CONF_PATH $ABS_CONF_PATH~~

CURRENT_PLAYLIST=$(grep playing $ABS_CONF_PATH | sed 's/playing //')
NUM_LINES=$(awk 'END { print NR }' $ABS_CONF_PATH)
X=$(($NUM_LINES-2))
NUM_PLAYLISTS=$(($X/4)) # don't know why one command isn't working for this
NEW_PLAYLIST=$((CURRENT_PLAYLIST+1))
NEW_PLAYLIST=$(($NEW_PLAYLIST % $NUM_PLAYLISTS))

sed -ie "s/^playing.*/playing $NEW_PLAYLIST/" $ABS_CONF_PATH
sed -ie "s/^active.*/active $NEW_PLAYLIST/" $ABS_CONF_PATH
    
sleep .4 # gives audacious the chance to shut down before restart
audacious --headless --play &