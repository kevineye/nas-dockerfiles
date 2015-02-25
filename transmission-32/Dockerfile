FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>
# copied from https://github.com/elventear/docker-transmission

# BUILD:
# docker build -t kevineye/transmission-32 .

# RUN:
# docker run --name transmission -d -p 12345:12345 -p 12345:12345/udp -p 9091:9091 -e ADMIN_PASS=$( read -p "Password: " -s PASSWORD && echo $PASSWORD ) -v /mnt/sdb1/Everything/Downloads/Torrents/TV:/var/lib/transmission-daemon/downloads -v /mnt/sdb1/Everything/Downloads/Torrents/Active:/var/lib/transmission-daemon/incomplete kevineye/transmission-32

# ADMIN:
# Log in to http://localhost:9091/transmission/web/ (transmission:<password>)

ENV TRANSMISSION_UID 0
ENV TRANSMISSION_GID 100
ENV TRANSMISSION_UMASK 0002

RUN apt-get install -yqq transmission-daemon

ADD settings.json /etc/transmission-daemon/settings.json
ADD run.sh /run.sh

RUN useradd -d / -M -U -u 1500 transmission

EXPOSE 9091
EXPOSE 12345

VOLUME /var/lib/transmission-daemon/downloads
VOLUME /var/lib/transmission-daemon/incomplete

CMD ["/bin/sh", "/run.sh"]
