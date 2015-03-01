FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>
# with help from https://github.com/nginxinc/docker-nginx/blob/master/Dockerfile

# BUILD
# docker build -t kevineye/plexconnect-32 .

# CONFIGURE HOST
# ifconfig eth0:1 192.168.1.152 netmask 255.255.255.0 up

# RUN
# docker run --name plexconnect -d --net=host -e IP_PLEXCONNECT=192.158.1.152 kevineye/plexconnect-32

RUN apt-get install -qqy python python-dev python-imaging curl unzip

ADD https://github.com/iBaa/PlexConnect/archive/master.zip /tmp/plexconnect.zip

RUN cd /opt \
 && unzip /tmp/plexconnect.zip \
 && mv PlexConnect-master plexconnect

ADD trailers.pem /opt/plexconnect/assets/certificates/trailers.pem
ADD Settings.cfg /opt/plexconnect/Settings.cfg
ADD run.sh /run.sh

ENV IP_PLEXCONNECT 0.0.0.0

EXPOSE 53/udp
EXPOSE 80
EXPOSE 443

CMD ["/bin/bash", "/run.sh"]
