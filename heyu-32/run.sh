#!/bin/sh

heyu upload

rm -f /var/run/apache2.pid /var/run/apache2/apache2.pid

/usr/sbin/apache2 -D FOREGROUND
