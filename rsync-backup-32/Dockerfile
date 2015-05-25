FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD
# docker build -t kevineye/rsync-backup-32 .

# RUN
# docker run --name rsync-backup -v /mnt/sdb1:/backup -v /etc/localtime:/etc/localtime kevineye/rsync-backup-32
# docker start -a rsync-backup

RUN apt-get install -yqq ssh rsync

ADD run.sh /run.sh
ADD ssh_config /root/.ssh/config
ADD id_rsa /root/.ssh/id_rsa
ADD id_rsa.pub /root/.ssh/id_rsa.pub

RUN chmod -R 500 /root/.ssh

ENV REMOTE_HOST backup@192.168.1.131
ENV REMOTE_DIR /mnt/eSata/backups

VOLUME /backup
 
CMD ["/bin/sh", "/run.sh"]
