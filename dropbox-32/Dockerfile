FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

ADD https://www.dropbox.com/download?plat=lnx.x86 /tmp/dropbox.tar.gz

RUN tar xzf /tmp/dropbox.tar.gz \
 && mkdir -p /home/data-user/Dropbox /home/data-user/.dropbox \
 && chown -R data-user:users /.dropbox-dist /home/data-user
 && chmod 775 /home/data-user/Dropbox /home/data-user/.dropbox

ADD run.sh /run.sh

VOLUME /home/data-user/.dropbox
VOLUME /home/data-user/Dropbox

USER data-user
 
CMD ["/bin/sh", "/run.sh"]
