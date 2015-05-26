FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

RUN apt-get install -yqq apache2 apache2-utils supervisor build-essential curl cpanminus docker.io || /bin/true # cgroup-lite will probably fail

# install perl modules
RUN cpanm Mojolicious autodie IPC::System::Simple YAML

RUN a2enmod headers rewrite proxy proxy_http cgi ssl \
 && mkdir -p /var/lock/apache2 \
 && chown www-data /var/lock/apache2 \
 && rm /var/www/html/index.html \
 && touch /var/www/html/index.html

# install app files
COPY . /app
RUN ln -s /app/router.conf /etc/apache2/conf-enabled/

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP users
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2

ADD supervisor.conf /etc/supervisor/conf.d/
ADD httpd-foreground /usr/local/bin/

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord"]
