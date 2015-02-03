FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD:
# docker build -t kevineye/registrator-32 .

# RUN:
# docker run --name registrator -d --link etcd:etcd -v /var/run/docker.sock:/tmp/docker.sock -h 192.168.1.151 kevineye/registrator-32 etcd://etcd:4001/services

ADD registrator-i386.tar.gz /bin

ENV DOCKER_HOST unix:///tmp/docker.sock

ENTRYPOINT ["/bin/registrator"]
