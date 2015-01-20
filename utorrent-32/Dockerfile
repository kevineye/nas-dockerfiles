FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

ADD http://download-new.utorrent.com/endpoint/utserver/os/linux-i386-debian-7-0/track/beta/ /tmp/utorrent.tar.gz

RUN cd /opt \
 && tar xvzf /tmp/utorrent.tar.gz \
 && ln -s /opt/$(ls /opt/|tail -1) /opt/utorrent-server \
 && rm -f /tmp/utorrent.tar.gz

EXPOSE 6881
EXPOSE 8080

VOLUME /Everything
VOLUME /opt/utorrent-server
 
CMD ["/opt/utorrent-server/utserver", "-settingspath", "/opt/utorrent-server", "-logfile", "/dev/stdout"]
