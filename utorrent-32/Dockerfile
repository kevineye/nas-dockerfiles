FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD:
# docker build -t kevineye/utorrent-32 .

# RUN:
# docker run --name utorrent-data -v /mnt/everything/Everything:/share kevineye/utorrent-32 echo data
# docker run --name utorrent -d -p 8080:8080 -p 6881:6881 --volumes-from utorrent-data kevineye/utorrent-32

# ADMIN:
# Log in to http://localhost:8080/gui/ (admin:<blank>)

ADD http://download-new.utorrent.com/endpoint/utserver/os/linux-i386-debian-7-0/track/beta/ /tmp/utorrent.tar.gz

RUN cd /opt \
 && tar xvzf /tmp/utorrent.tar.gz \
 && mv /opt/$(ls /opt/|tail -1) /opt/utorrent-server \
 && useradd -d / -M -U -u 1500 utorrent \
 && mkdir /share \
 && chown data-user:users /opt/utorrent-server /share

ADD run.sh /run.sh

EXPOSE 6881
EXPOSE 8080

VOLUME /share
VOLUME /opt/utorrent-server

USER data-user
 
CMD ["/bin/sh", "/run.sh"]
