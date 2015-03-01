#!/bin/bash

TARGETDIR=/usr/local/crashplan

. ${TARGETDIR}/install.vars
. ${TARGETDIR}/bin/run.conf

export LANG="en_US.UTF-8"

FULL_CP="$TARGETDIR/lib/com.backup42.desktop.jar:$TARGETDIR/lang"

cd ${TARGETDIR}

exec nice -n 19 java $SRV_JAVA_OPTS -classpath $FULL_CP com.backup42.service.CPService
