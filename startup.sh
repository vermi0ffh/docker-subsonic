#!/bin/sh

###################################################################################
# Shell script for starting Subsonic.  See http://subsonic.org.
#
#
# Adpated for unRAID by Carlos Hernandez <carlos@techbyte.ca>
#
###################################################################################

HOME=/subsonic
HOST=0.0.0.0
PORT=${4040:-WEB_PORT}
HTTPS_PORT=${0:-SSL_PORT}
CONTEXT_PATH=/
MAX_MEMORY=200
MUSIC_FOLDER=/music
PODCAST_FOLDER=/podcasts
PLAYLIST_FOLDER=/playlists


SUBSONIC_USER=nobody

export LANG=POSIX
export LC_ALL=en_US.UTF-8

/usr/bin/subsonic --home=$HOME \
                  --host=$HOST \
                  --port=$PORT \
                  --https-port=$HTTPS_PORT \
                  --max-memory=$MAX_MEMORY \
                  --default-music-folder=$MUSIC_FOLDER \
		  --default-podcast-folder=$PODCAST_FOLDER \
                  --default-playlist-folder=$PLAYLIST_FOLDER
sleep 5
tail -f /subsonic/subsonic_sh.log
