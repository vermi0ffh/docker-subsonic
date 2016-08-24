#!/bin/bash

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Configure user nobody to match unRAID's settings
usermod -u 99 nobody
usermod -g 100 nobody
usermod -d /subsonic nobody
mkdir /subsonic
chown -R nobody:users /subsonic

# Disable SSH
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################

# Repositories
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ED8E640A
echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted' > /etc/apt/sources.list
echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted' >> /etc/apt/sources.list
echo 'deb http://ppa.launchpad.net/mc3man/trusty-media/ubuntu trusty main' >> /etc/apt/sources.list


# Install Dependencie
apt-get update -qq
apt-get install -qy ffmpeg wget openjdk-7-jre-headless

#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################
# CONFIG
cat <<'EOT' > /etc/my_init.d/config.sh
#!/bin/bash

# Fix the timezone
if [[ $(cat /etc/timezone) != $TZ ]] ; then
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
fi

# Use system install of ffmpeg for transcoding
[ ! -d /subsonic/transcode ] || rm -r /subsonic/transcode
mkdir -p /subsonic/transcode
ln -s "$(which ffmpeg)" /subsonic/transcode/ffmpeg
chown -R nobody:users /subsonic
EOT

# Subsonic
mkdir -p /etc/service/subsonic
cat <<'EOT' > /etc/service/subsonic/run
#!/bin/bash

#########################################################################
# Shell script for starting Subsonic.  See http://subsonic.org. 	#
#									#
# Adpated for unRAID by Carlos Hernandez <carlos@techbyte.ca>		#
#									#
#########################################################################
SUBSONIC_HOME=/subsonic
SUBSONIC_HOST=0.0.0.0
SUBSONIC_PORT=${WEB_PORT:-4040}
SUBSONIC_HTTPS_PORT=${SSL_PORT:-0}
SUBSONIC_CONTEXT_PATH=/
SUBSONIC_MAX_MEMORY=${MAX_MEM:-150}
SUBSONIC_PIDFILE=
SUBSONIC_DEFAULT_MUSIC_FOLDER=/music
SUBSONIC_DEFAULT_PODCAST_FOLDER=/podcasts
SUBSONIC_DEFAULT_PLAYLIST_FOLDER=/playlists


# Use JAVA_HOME if set, otherwise assume java is in the path.
JAVA=java
if [ -e "${JAVA_HOME}" ]
    then
    JAVA=${JAVA_HOME}/bin/java
fi

# Create Subsonic home directory.
[ ! -e ${SUBSONIC_HOME} ] && mkdir -p ${SUBSONIC_HOME}
LOG=${SUBSONIC_HOME}/subsonic_sh.log
rm -f ${LOG}

cd /usr/share/subsonic/

export LANG=POSIX
export LC_ALL=en_US.UTF-8

exec /sbin/setuser nobody ${JAVA} -Xmx${SUBSONIC_MAX_MEMORY}m \
  -Dsubsonic.home=${SUBSONIC_HOME} \
  -Dsubsonic.host=${SUBSONIC_HOST} \
  -Dsubsonic.port=${SUBSONIC_PORT} \
  -Dsubsonic.httpsPort=${SUBSONIC_HTTPS_PORT} \
  -Dsubsonic.contextPath=${SUBSONIC_CONTEXT_PATH} \
  -Dsubsonic.defaultMusicFolder=${SUBSONIC_DEFAULT_MUSIC_FOLDER} \
  -Dsubsonic.defaultPodcastFolder=${SUBSONIC_DEFAULT_PODCAST_FOLDER} \
  -Dsubsonic.defaultPlaylistFolder=${SUBSONIC_DEFAULT_PLAYLIST_FOLDER} \
  -Djava.awt.headless=true \
  -verbose:gc \
  -jar subsonic-booter-jar-with-dependencies.jar > ${LOG} 2>&1 

EOT

chmod -R +x /etc/service/ /etc/my_init.d/

#########################################
##             INSTALLATION            ##
#########################################

# Install Subsonic
wget -q http://downloads.sourceforge.net/project/subsonic/subsonic/6.0/subsonic-6.0.deb -O /tmp/subsonic.deb
dpkg -i /tmp/subsonic.deb && rm /tmp/subsonic.deb

#########################################
##                 CLEANUP             ##
#########################################

# Clean APT install files
apt-get clean -y
rm -rf /var/lib/apt/lists/* /var/cache/* /var/tmp/* /var/subsonic
