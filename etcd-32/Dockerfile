FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD:
# docker build -t kevineye/etcd-32 .

# RUN:
# docker run --name etcd-data kevineye/etcd-32 --version
# docker run --name etcd -d -p 4001:4001 -p 7001:7001 --volumes-from etcd-data kevineye/etcd-32 -name etcd1 -addr 192.168.1.151:4001

ADD etcd-0.4.6-i386.tar.gz /bin

EXPOSE 4001
EXPOSE 7001
EXPOSE 2379
EXPOSE 2380

VOLUME /data

ENTRYPOINT ["etcd", "-data-dir=/data"]