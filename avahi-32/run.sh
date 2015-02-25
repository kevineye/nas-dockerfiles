#!/bin/sh

rm -rf /var/run/avahi-daemon

exec /usr/sbin/avahi-daemon
