#!/bin/sh

sed -i -e "s/:1500:1500:/:$DB_UID:$DB_GID:/" /etc/passwd
sed -i -e "s/dropbox:x:1500:/dropbox:x:$DB_GID:/" /etc/group

chown ${DB_UID}:${DB_GID} /Dropbox /.dropbox

exec su dropbox -c "umask $DB_UMASK; /.dropbox-dist/dropboxd"
