#!/bin/bash

killall audacious

REL_CONF_PATH='/.config/audacious/playlist-state'
ABS_CONF_PATH=$HOME$REL_CONF_PATH

# create a backup, must be restored manually if there's a problem
cp $ABS_CONF_PATH $ABS_CONF_PATH~~

CURRENT_PLAYLIST=$(grep playing $ABS_CONF_PATH | sed 's/playing //')
NUM_LINES=$(awk 'END { print NR }' $ABS_CONF_PATH) # wc wasn't playing nice
X=$(($NUM_LINES-2))
NUM_PLAYLISTS=$(($X/4)) # don't know why one command isn't working for the math
NEW_PLAYLIST=$((CURRENT_PLAYLIST+1))
NEW_PLAYLIST=$(($NEW_PLAYLIST % $NUM_PLAYLISTS))

#modify the config file for the audacious restart
sed -ie "s/^playing.*/playing $NEW_PLAYLIST/" $ABS_CONF_PATH
sed -ie "s/^active.*/active $NEW_PLAYLIST/" $ABS_CONF_PATH
    
sleep .4 # gives audacious the chance to finish shutting down before restart
audacious --headless --play &