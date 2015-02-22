#!/bin/sh

rm -f /var/run/avahi-daemon

exec /usr/sbin/avahi-daemon
