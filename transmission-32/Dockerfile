FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>
# copied from https://github.com/elventear/docker-transmission

RUN apt-get install -yqq transmission-daemon

ADD settings.json /etc/transmission-daemon/settings.json
ADD run.sh /run.sh

RUN chown data-user:users /var/lib/transmission-daemon \
 && chown -R data-user /etc/transmission-daemon

EXPOSE 12345
EXPOSE 9091

VOLUME /var/lib/transmission-daemon/downloads
VOLUME /var/lib/transmission-daemon/incomplete
VOLUME /var/lib/transmission-daemon/info
VOLUME /etc/transmission-daemon

USER data-user

CMD ["/bin/sh", "/run.sh"]
