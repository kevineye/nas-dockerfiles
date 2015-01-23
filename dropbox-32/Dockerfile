FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD:
# docker build -t kevineye/dropbox-32 .

# RUN:
# docker run --name dropbox-data kevineye/dropbox-32 echo data
# docker run --name dropbox -d --volumes-from dropbox-data -v /mnt/sdb1/Everything/Dropbox:/Dropbox kevineye/dropbox-32

# CONFIG:
# Follow link from docker logs -f dropbox

ENV DB_UID 0
ENV DB_GID 100
ENV DB_UMASK 0002

ADD https://www.dropbox.com/download?plat=lnx.x86 /tmp/dropbox.tar.gz

RUN tar xzf /tmp/dropbox.tar.gz \
 && useradd -d / -M -U -u 1500 dropbox

ADD run.sh /run.sh

VOLUME /.dropbox /Dropbox
 
CMD ["/bin/sh", "/run.sh"]
