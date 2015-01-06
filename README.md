#SubSonic

## Description:

Subsonic is an open source, web-based media server.  
  
Because Subsonic was written in Java, it may be run on any operating system with Java support.  
Subsonic supports streaming to multiple clients simultaneously, and supports any streamable media (including MP3, AAC, and Ogg).  
Subsonic also supports on-the-fly media conversion (through the use of plugins) of most popular media formats, including WMA, FLAC, and more.  
  
This repository contains all necessary files to build a Docker image for "SubSonic" - (http://www.subsonic.org/).
Specifically for use within an unRAID environment.


![Alt text](http://i.imgur.com/ue0BK5z.png "")

## How to use this image

### start a Subsonic instance

```
docker run -d --net=host -v /*your_subsonichome_location*:/subsonic \
                         -v /*your_music_folder_location*:/music \
                         -v /*your_podcast_folder_location*:/podcasts \
                         -e TZ=America/Edmonton
                         --name=subsonic hurricane/docker-subsonic
```

## Volumes:

#### `/subsonic`

Home directory for subsonic, subsonic stores it's log, database properties in this folder. (i.e. /opt/appdata/subsonic)

#### `/music`

Defualt music folder. If remote share ensure it's mounted before run command is issued. 
(i.e. /opt/downloads/music or /media/Tower/music)

#### `/podcasts`

Defualt podcasts folder. If remote share ensure it's mounted before run command is issued.
(i.e. /opt/downloads/podcasts or /media/Tower/podcasts)

## Environment Variables

The Subsonic image uses one optional enviromnet variable.

`TZ`  
This environment variable is used to set the [TimeZone] of the container.

[TimeZone]: http://en.wikipedia.org/wiki/List_of_tz_database_time_zones


## Build from docker file (Info only, not requried.):

```
git clone https://github.com/HurricaneHernandez/docker-subsonic.git 
cd docker-subsonic
docker build -t subsonic . 
```
