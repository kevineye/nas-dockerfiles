FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

ADD https://downloads.plex.tv/plex-media-server/0.9.11.7.803-87d0708/plexmediaserver_0.9.11.7.803-87d0708_i386.deb /tmp/plexmediaserver.deb

RUN dpkg -i /tmp/plexmediaserver.deb

EXPOSE 32400

VOLUME /Everything
VOLUME /root/Library
 
CMD ["start_pms"]
