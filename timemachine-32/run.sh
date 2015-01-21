#!/bin/sh

set -e

if [ ! -e /.initialized ]; then
    if [ -z $AFPD_LOGIN ]; then
        echo "no AFPD_LOGIN specified!"
        exit 1
    fi

    if [ -z $AFPD_PASSWORD ]; then
        echo "no AFPD_PASSWORD specified!"
        exit 1
    fi

    if [ -z $AFPD_NAME ]; then
        echo "no AFPD_NAME specified!"
        exit 1
    fi

    useradd $AFPD_LOGIN -M
    echo $AFPD_LOGIN:$AFPD_PASSWORD | chpasswd

    echo "- -tcp -noddp -uamlist uams_randnum.so,uams_dhx.so,uams_dhx2.so -nosavepassword -setuplog \"default log_info /dev/stdout\"" > /etc/netatalk/afpd.conf

    if [ -z $AFPD_SIZE_LIMIT ]; then
        echo "/TimeMachine \"${AFPD_NAME}\" allow:$AFPD_LOGIN rwlist:$AFPD_LOGIN fperm:664 dperm:775 cnidscheme:dbd options:usedots,uperm,tm" > /etc/netatalk/AppleVolumes.default
    else
        echo "/TimeMachine \"${AFPD_NAME}\" allow:$AFPD_LOGIN rwlist:$AFPD_LOGIN fperm:664 dperm:775 cnidscheme:dbd options:usedots,uperm,tm volsizelimit:$AFPD_SIZE_LIMIT" > /etc/netatalk/AppleVolumes.default
    fi

    touch /.initialized
fi

chown $AFPD_LOGIN /TimeMachine

exec ionice -c 3 /usr/bin/supervisord -n
