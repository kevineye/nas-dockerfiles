FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

ADD https://www.dropbox.com/download?plat=lnx.x86 /tmp/dropbox.tar.gz

RUN cd /home \
 && tar xzf /tmp/dropbox.tar.gz

EXPOSE 17500

VOLUME /home/.dropbox
VOLUME /home/Dropbox
 
CMD ["/home/.dropbox-dist/dropboxd"]
