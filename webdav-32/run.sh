#!/bin/sh

if [ ! -f "/etc/apache2/webdav.password" ]; then
    htpasswd -cb /etc/apache2/webdav.password webdav $PASSWORD
    chown www-data:www-data /etc/apache2/webdav.password
    chmod 600 /etc/apache2/webdav.password
fi

umask 0002

/usr/sbin/apache2 -D FOREGROUND