FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>
# with help from https://github.com/nginxinc/docker-nginx/blob/master/Dockerfile

# BUILD
# docker build -t kevineye/nginx-32 .

# RUN
# docker run --name nginx-public -d -p 80:80 -v /mnt/sdb1/Everything/BTSync/Public:/usr/share/nginx/html:ro kevineye/nginx-32

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.7.9-1~trusty

RUN apt-get update && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} && \
    rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx"]

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]