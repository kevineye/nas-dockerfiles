FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>
# with help from https://github.com/nginxinc/docker-nginx/blob/master/Dockerfile

RUN apt-get install -yqq nginx

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# use customized config
COPY . /app
RUN ln -sf /app/default.conf /etc/nginx/sites-enabled/default

VOLUME ["/var/cache/nginx"]

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]