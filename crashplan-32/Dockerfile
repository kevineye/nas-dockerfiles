FROM kevineye/base-32
MAINTAINER Kevin Eye <kevineye@gmail.com>

# BUILD
# docker build -t kevineye/crashplan-32 .

# RUN
# docker run --name crashplan-data -v /mnt/sdb1:/backup -v /etc/localtime:/etc/localtime kevineye/crashplan-32 echo data
# docker run --name crashplan -d -p 4242:4242 -p 4243:4243 -v /mnt/sdb1:/backup --volumes-from crashplan-data kevineye/crashplan-32

# ADMIN
# See headless config article:
# http://support.code42.com/CrashPlan/Latest/Configuring/Using_CrashPlan_On_A_Headless_Computer

RUN apt-get install -yqq software-properties-common \
 && add-apt-repository -y ppa:webupd8team/java \
 && apt-get update -qq \
 && echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
 && apt-get install -yqq grep sed cpio gzip curl oracle-java7-installer

RUN cd /tmp \
 && curl -s http://download1.us.code42.com/installs/linux/install/CrashPlan/CrashPlan_3.7.0_Linux.tgz | tar xzvf -

ADD crashplan-install.sh /tmp/CrashPlan-install/crashplan-install.sh

RUN cd /tmp/CrashPlan-install \
 && ./crashplan-install.sh

ADD run.sh /run.sh

EXPOSE 4243
EXPOSE 4242

VOLUME /var/lib/crashplan
VOLUME /usr/local/crashplan

VOLUME /backup
 
CMD ["/bin/sh", "/run.sh"]
