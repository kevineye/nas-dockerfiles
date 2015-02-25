#!/bin/sh

sed -i -e "s/:1500:1500:/:$TRANSMISSION_UID:$TRANSMISSION_GID:/" /etc/passwd
sed -i -e "s/transmission:x:1500:/transmission:x:$TRANSMISSION_GID:/" /etc/group

CONFIG_DIR=/etc/transmission-daemon
SETTINGS=$CONFIG_DIR/settings.json
TRANSMISSION=/usr/bin/transmission-daemon

if [ ! -f ${SETTINGS}.bak ]; then
    if [ -z $ADMIN_PASS ]; then
        echo Please provide a password for the 'transmission' user via the ADMIN_PASS enviroment variable.
        exit 1
    fi

    sed -i.bak -e "s/@password@/$ADMIN_PASS/" $SETTINGS 
fi

chown ${TRANSMISSION_UID}:${TRANSMISSION_GID} /var/lib/transmission-daemon /etc/transmission-daemon

exec su transmission -c "umask $UT_UMASK; $TRANSMISSION -f --no-portmap --config-dir $CONFIG_DIR --log-info"
