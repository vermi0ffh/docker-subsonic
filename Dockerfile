# Builds docker image for subsonic
FROM ubuntu:trusty
MAINTAINER Carlos Hernandez <carlos@techbyte.ca>

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Set locale to UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales

# Update Ubuntu
RUN apt-mark hold initscripts udev plymouth mountall;\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ED8E640A;\
    echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted' > /etc/apt/sources.list;\
    echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted' >> /etc/apt/sources.list;\
    echo 'deb http://ppa.launchpad.net/mc3man/trusty-media/ubuntu trusty main' >> /etc/apt/sources.list;\
    apt-get update && apt-get -qy dist-upgrade && apt-get -q update

# Install ffmpeg
RUN apt-get install -qy --force-yes ffmpeg

# Set user nobody to uid and gid of unRAID
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

# install dependencies for subsonic
RUN apt-get install -qy openjdk-6-jre
RUN apt-get clean

# install subsonic
ADD http://downloads.sourceforge.net/project/subsonic/subsonic/5.2.1/subsonic-5.2.1.deb /tmp/subsonic.deb
RUN dpkg -i /tmp/subsonic.deb && rm /tmp/subsonic.deb

RUN mkdir /subsonic && chown -R nobody:users /subsonic

ADD startup.sh /startup.sh

VOLUME [/subsonic]
VOLUME [/music]
VOLUME [/podcasts]

EXPOSE 4040
EXPOSE 4050

USER nobody
ENTRYPOINT ["/startup.sh"]
