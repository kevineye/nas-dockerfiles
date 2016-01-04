FROM debian
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apt-get -q update \
 && apt-get install -y -q transmission-daemon transmission-cli transmission-common

ADD settings.json /root/settings.json

RUN mkdir /config \
 && mv /root/settings.json /config/settings.json \
 && mkdir /downloads \
 && mkdir /incomplete \
 && chmod -R a+w /config /downloads /incomplete /var/lib/transmission-daemon

EXPOSE 12345
EXPOSE 9091

VOLUME /downloads
VOLUME /incomplete
VOLUME /config

CMD ["/usr/bin/transmission-daemon", "-f", "--no-portmap", "--config-dir", "/config", "--log-info"]
