FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

ADD https://download-cdn.getsyncapp.com/stable/linux-i386/BitTorrent-Sync_i386.tar.gz /tmp/bittorrent_sync.tar.gz

RUN mkdir /opt/btsync \
 && cd /opt/btsync \
 && tar xzf /tmp/bittorrent_sync.tar.gz \
 && mkdir -p /share /opt/btsync/.sync \
 && chown data-user:users /share /opt/btsync/.sync

ADD btsync.conf /etc/btsync.conf
ADD run.sh /run.sh

EXPOSE 3838/udp
EXPOSE 5555
EXPOSE 8888

VOLUME /share
VOLUME /opt/btsync/.sync

USER data-user

CMD ["/bin/sh", "/run.sh"]
