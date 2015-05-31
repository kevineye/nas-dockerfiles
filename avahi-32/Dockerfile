FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apt-get install -yqq avahi-daemon || /bin/true # libpam-systemd will probably fail

ADD afpd.service /etc/avahi/services/afpd.service
ADD avahi-daemon.conf /etc/avahi/avahi-daemon.conf
ADD run.sh /run.sh

CMD ["/bin/sh", "/run.sh"]