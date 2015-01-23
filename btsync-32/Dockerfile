FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD:
# docker build -t kevineye/btsync-32 .

# RUN:
# docker run --name btsync-data kevineye/btsync-32 echo data
# docker run --name btsync -d -p 8888:8888/tcp -p 5555:5555/tcp -p 3838:3838/udp --volumes-from btsync-data -v /mnt/sdb1/Everything:/share kevineye/btsync-32

# ADMIN:
# http://localhost:8888/gui/

ENV BT_UID 0
ENV BT_GID 100
ENV BT_UMASK 0002

ADD http://download.getsyncapp.com/endpoint/btsync/os/linux-i386/track/stable /tmp/bittorrent_sync.tar.gz

RUN mkdir /opt/btsync \
 && cd /opt/btsync \
 && tar xzf /tmp/bittorrent_sync.tar.gz \
 && rm -f /tmp/bittorrent_sync.tar.gz \
 && mkdir -p /share /opt/btsync/.sync \
 && useradd -d / -M -U -u 1500 btuser

ADD btsync.conf /etc/btsync.conf
ADD run.sh /run.sh

EXPOSE 3838/udp 5555 8888
VOLUME /share /opt/btsync/.sync

CMD ["/bin/sh", "/run.sh"]
