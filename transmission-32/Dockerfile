FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>
# copied from https://github.com/elventear/docker-transmission

ENV TRANSMISSION_UID 0
ENV TRANSMISSION_GID 100
ENV TRANSMISSION_UMASK 0002

RUN apt-get install -yqq transmission-daemon

ADD settings.json /etc/transmission-daemon/settings.json
ADD run.sh /run.sh

RUN useradd -d / -M -U -u 1500 transmission

EXPOSE 12345

VOLUME /var/lib/transmission-daemon/downloads
VOLUME /var/lib/transmission-daemon/incomplete
VOLUME /var/lib/transmission-daemon/info
VOLUME /etc/transmission-daemon

CMD ["/bin/sh", "/run.sh"]
