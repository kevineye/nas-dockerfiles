FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apt-get -yqq install ddclient curl sendmail libjson-any-perl libio-socket-ssl-perl patch

RUN curl -o /tmp/ddclient.patch http://blog.peter-r.co.uk/uploads/ddclient-3.8.0-cloudflare-22-6-2014.patch \
 && patch /usr/sbin/ddclient < /tmp/ddclient.patch

ADD ddclient.conf /etc/ddclient.conf
ADD run.sh /run.sh

CMD ["/bin/sh", "/run.sh"]

