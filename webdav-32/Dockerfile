FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apt-get -yqq install apache2 apache2-utils

RUN a2enmod dav dav_fs \
 && mkdir /share \
 && chown www-data:users /share \
 && mkdir -p /var/lock/apache2 \
 && chown www-data /var/lock/apache2 \
 && rm /var/www/html/index.html \
 && touch /var/www/html/index.html

ADD run.sh /run.sh
ADD webdav.conf /etc/apache2/sites-enabled/webdav.conf

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP users
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2

EXPOSE 80
VOLUME /share
 
CMD ["/bin/sh", "/run.sh"]
