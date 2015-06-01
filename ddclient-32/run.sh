#!/bin/sh

SETTINGS=/etc/ddclient.conf

if [ ! -f ${SETTINGS}.bak ]; then
    sed -i.bak -e "s/@CF_DOMAIN@/$CF_DOMAIN/; s/@CF_HOST@/$CF_HOST/; s/@CF_LOGIN@/$CF_LOGIN/; s/@CF_APIKEY@/$CF_APIKEY/" $SETTINGS
fi

#ddclient -daemon 0 -debug -verbose -noquiet
ddclient -foreground -daemon 1800
