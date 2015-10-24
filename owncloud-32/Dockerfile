FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apt-get install -yqq wget

RUN wget -nv https://download.owncloud.org/download/repositories/8.2/xUbuntu_14.04/Release.key -O Release.key \
 && apt-key add - < Release.key \
 && rm Release.key \
 && sh -c "echo 'deb http://download.owncloud.org/download/repositories/8.2/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list" \
 && apt-get update \
 && apt-get install -yqq owncloud

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP users
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2

VOLUME /var/www/owncloud

EXPOSE 80
COPY apache2-foreground /usr/local/bin/
CMD ["apache2-foreground"]
