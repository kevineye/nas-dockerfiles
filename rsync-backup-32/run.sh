#!/bin/sh

set -e

TIMESTAMP=`date +%Y%m%d-%H%M`
LATEST_COMPLETE=`ssh $REMOTE_HOST ls -d $REMOTE_DIR/complete-* | sort -r | head -1`
[ $LATEST_COMPLETE = "" ] && LINK_DEST_OPT= || LINK_DEST_OPT=--link-dest=$LATEST_COMPLETE

rsync -a --stats --delete --partial --rsync-path=/opt/bin/rsync $LINK_DEST_OPT /backup/Everything $REMOTE_HOST:$REMOTE_DIR/partial-$TIMESTAMP/ && ssh $REMOTE_HOST mv $REMOTE_DIR/partial-$TIMESTAMP $REMOTE_DIR/complete-$TIMESTAMP

ssh $REMOTE_HOST '/opt/local/bin/purge-decay '$REMOTE_DIR'/complete-*'

rsync -a --stats --delete --partial --rsync-path=/opt/bin/rsync /backup/TimeMachine $REMOTE_HOST:$REMOTE_DIR/

ssh $REMOTE_HOST df -h | grep /mnt/eSata
