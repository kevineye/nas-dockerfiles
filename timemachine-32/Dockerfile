FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>
# With help from https://github.com/bobrik/time-container

# BUILD
# docker build -t kevineye/timemachine-32 .

# RUN
# docker run --name timemachine -d -p 548:548 -v /mnt/everything/TimeMachine:/share -e AFPD_PASSWORD=$( read -p "Password: " -s PASSWORD && echo $PASSWORD ) -e AFPD_SIZE_LIMIT=1000000 kevineye/timemachine-32

RUN apt-get install -yq supervisor netatalk || /bin/true # libpam-systemd will probably fail

RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD run.sh /run.sh

ENV AFPD_LOGIN tmuser
ENV AFPD_NAME TimeMachine

EXPOSE 548
VOLUME /share
 
CMD ["/bin/sh", "/run.sh"]
