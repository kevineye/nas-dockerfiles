FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD
# docker build -t kevineye/plex-32 .

# RUN
# docker run --name plex-data -v /mnt/sdb1/Everything:/share kevineye/plex-32 echo data
# docker run --name plex -d --net=host --volumes-from plex-data kevineye/plex-32

# MANAGE
# Log in to http://192.168.1.151:32400/web

ADD https://downloads.plex.tv/plex-media-server/0.9.11.7.803-87d0708/plexmediaserver_0.9.11.7.803-87d0708_i386.deb /tmp/plexmediaserver.deb

RUN dpkg -i /tmp/plexmediaserver.deb
RUN mkdir -p /config/tmp \
 && chown -R plex:plex /config \
 && chown -R 0775 /config

ADD plexmediaserver /etc/default/plexmediaserver

VOLUME /share
VOLUME /config
 
CMD ["start_pms"]
