#!/bin/sh

sed -i -e "s/@IP_PLEXCONNECT@/$IP_PLEXCONNECT/" /opt/plexconnect/Settings.cfg

exec /usr/bin/python /opt/plexconnect/PlexConnect.py