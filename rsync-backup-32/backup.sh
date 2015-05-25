#!/bin/bash
DIR="$(dirname "$(test -L "$0" && readlink "$0" || echo "$0")")"
$DIR/standalone.sh 2>&1 | tee /tmp/last-backup | $DIR/format_report.pl | /usr/sbin/sendmail -t
