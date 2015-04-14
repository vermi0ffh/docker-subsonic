#!/bin/bash

###################################################################################
# Shell script for starting Subsonic.  See http://subsonic.org.
#
#
# Adpated for unRAID by Carlos Hernandez <carlos@techbyte.ca>
#
###################################################################################

# Apparently, Subsonic does not accept paths in the Transcoding settings.
[ ! -d /subsonic/transcode ] && rm -r /subsonic/transcode
[ ! -d /subsonic/transcode ] && mkdir -p /subsonic/transcode
ln -s "$(which ffmpeg)" /subsonic/transcode/ffmpeg

HOME=/subsonic
HOST=0.0.0.0
PORT=${WEB_PORT:-4040}
HTTPS_PORT=${SSL_PORT:-0}
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
