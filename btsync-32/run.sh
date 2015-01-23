#!/bin/sh

sed -i -e "s/:1500:1500:/:$BT_UID:$BT_GID:/" /etc/passwd
sed -i -e "s/btuser:x:1500:/btuser:x:$BT_GID:/" /etc/group

chown ${BT_UID}:${BT_GID} /share /opt/btsync/.sync

exec su btuser -c "umask $BT_UMASK; /opt/btsync/btsync --nodaemon --config /etc/btsync.conf --log /dev/stdout"
