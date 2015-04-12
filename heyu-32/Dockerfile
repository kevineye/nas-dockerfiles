FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apt-get -yqq install apache2 apache2-utils make gcc supervisor

ADD heyu-2.11-rc1.tar.gz /tmp

RUN cd /tmp/heyu-2.11-rc1 \
 && ./configure --build=i386-linux \
 && make \
 && make install

RUN rm -rf /usr/local/etc/heyu \
 && mkdir -p /usr/local/var/tmp/heyu \
 && mkdir -p /usr/local/var/lock \
 && chmod 777 /usr/local/var/tmp/heyu \
 && chmod 777 /usr/local/var/lock

RUN a2enmod headers cgi \
 && mkdir -p /var/lock/apache2 \
 && chown www-data /var/lock/apache2 \
 && rm /var/www/html/index.html \
 && touch /var/www/html/index.html

ADD config /usr/local/etc/heyu
ADD app /app
ADD run.sh /run.sh
ADD home-control.conf /etc/apache2/sites-enabled/home-control.conf

RUN chmod 666 /usr/local/etc/heyu/x10state

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP users
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2

ADD supervisor.conf /etc/supervisor/conf.d/
ADD httpd-foreground /usr/local/bin/

EXPOSE 80

CMD ["/usr/bin/supervisord"]

