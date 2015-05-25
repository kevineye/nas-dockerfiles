FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD:
# docker build -t kevineye/varnish-auto-32 .

# RUN
# docker run --name varnish -d --link etcd:etcd -p 80:80 kevineye/varnish-auto-32

RUN apt-get install -yqq make gcc cpp curl python-docutils ncurses-dev pkg-config libpcre3-dev libedit-dev supervisor

RUN cd /home \
 && curl https://repo.varnish-cache.org/source/varnish-4.0.2.tar.gz | tar xzvf - \
 && cd varnish-4.0.2 \
 && ./configure \
 && make \
 && make install \
 && ldconfig

ADD etcd-0.4.6-i386.tar.gz /bin

ADD confd-0.7.0-i386.tar.gz /bin
RUN mkdir -p /etc/confd/conf.d /etc/confd/templates

ADD varnish.confd /etc/confd/conf.d/varnish.toml
ADD varnish.vcl.tmpl /etc/confd/templates/
ADD default.vcl /etc/varnish/
ADD varnish.supervisor.conf /etc/supervisor/conf.d/

EXPOSE 80

CMD ["/usr/bin/supervisord"]
