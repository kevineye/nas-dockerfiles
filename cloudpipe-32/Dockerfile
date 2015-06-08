FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apt-get install -yqq git cpanminus make libio-socket-ssl-perl

RUN cpanm --notest Mojolicious autodie IPC::System::Simple

RUN git clone https://github.com/kevineye/cloudpipe.git /app

ENV CLOUD_STORAGE /var/lib/cloud

VOLUME /var/lib/cloud

EXPOSE 443

CMD [ "/app/server.pl", "daemon", "-l", "https://*:443" ]
