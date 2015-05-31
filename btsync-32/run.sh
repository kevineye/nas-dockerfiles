#!/bin/sh

umask 02
/opt/btsync/btsync --nodaemon --config /etc/btsync.conf --log /dev/stdout
