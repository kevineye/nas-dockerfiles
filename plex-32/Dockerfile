FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

ADD https://downloads.plex.tv/plex-media-server/0.9.12.1.1079-b655370/plexmediaserver_0.9.12.1.1079-b655370_i386.deb /tmp/plexmediaserver.deb

RUN dpkg -i /tmp/plexmediaserver.deb
RUN mkdir -p /config/tmp \
 && chown -R plex:plex /config \
 && chown -R 0775 /config

ADD plexmediaserver /etc/default/plexmediaserver

VOLUME /share
VOLUME /config
 
CMD ["start_pms"]
