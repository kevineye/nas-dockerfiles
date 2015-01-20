FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

ADD http://download.getsyncapp.com/endpoint/btsync/os/linux-i386/track/stable /tmp/bittorrent_sync.tar.gz

RUN mkdir /opt/btsync \
 && cd /opt/btsync \
 && tar xzf /tmp/bittorrent_sync.tar.gz \
 && rm -f /tmp/bittorrent_sync.tar.gz

ADD btsync.conf /etc/btsync.conf

EXPOSE 3838/udp
EXPOSE 5555
EXPOSE 8888

VOLUME /Everything
VOLUME /opt/btsync/.sync

CMD ["/opt/btsync/btsync", "--nodaemon", "--config", "/etc/btsync.conf", "--log", "/dev/stdout"]
