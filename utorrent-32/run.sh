#!/bin/sh

umask 02
/opt/utorrent-server/utserver -settingspath /opt/utorrent-server -logfile /dev/stdout
