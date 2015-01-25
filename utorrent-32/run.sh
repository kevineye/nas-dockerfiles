#!/bin/sh

sed -i -e "s/:1500:1500:/:$UT_UID:$UT_GID:/" /etc/passwd
sed -i -e "s/utorrent:x:1500:/utorrent:x:$UT_GID:/" /etc/group

chown ${UT_UID}:${UT_GID} /share /opt/utorrent-server

exec su utorrent -c "umask $UT_UMASK; /opt/utorrent-server/utserver -settingspath /opt/utorrent-server -logfile /dev/stdout"
