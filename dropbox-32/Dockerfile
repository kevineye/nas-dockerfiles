FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

ADD https://www.dropbox.com/download?plat=lnx.x86 /tmp/dropbox.tar.gz

RUN tar xzf /tmp/dropbox.tar.gz \
 && mkdir /Dropbox /.dropbox \
 && chown data-user:users /Dropbox /.dropbox \
 && chmod 775 /Dropbox /.dropbox

ADD run.sh /run.sh

VOLUME /.dropbox
VOLUME /Dropbox
 
CMD ["/bin/sh", "/run.sh"]
