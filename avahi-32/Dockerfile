FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD
# docker build -t kevineye/avahi-32 .

# RUN
# docker run --name avahi -d --net=host kevineye/avahi-32

RUN apt-get install -yqq avahi-daemon || /bin/true # libpam-systemd will probably fail

ADD afpd.service /etc/avahi/services/afpd.service
ADD avahi-daemon.conf /etc/avahi/avahi-daemon.conf
ADD run.sh /run.sh

CMD ["/bin/sh", "/run.sh"]