FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>
# With help from https://github.com/bobrik/time-container

RUN apt-get install -yqq avahi-daemon supervisor netatalk || /bin/true # libpam-systemd will probably fail

RUN mkdir -p /var/log/supervisor \
 && mkdir /TimeMachine
 
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD ./run.sh /run.sh

EXPOSE 548

VOLUME /TimeMachine
 
CMD ["/bin/sh", "/run.sh"]