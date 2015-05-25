#!/bin/sh
set -e

REMOTE_HOST=backup@192.168.1.131
REMOTE_DIR=/mnt/eSata/backups
SSH_KEY=/Everything/BTSync/Docker/rsync-backup-32/id_rsa
LOCAL_DIR=/mnt/sdb1

TIMESTAMP=`date +%Y%m%d-%H%M`
LATEST_COMPLETE=`ssh -i $SSH_KEY $REMOTE_HOST ls -d $REMOTE_DIR/complete-* | sort -r | head -1`
[ $LATEST_COMPLETE = "" ] && LINK_DEST_OPT= || LINK_DEST_OPT=--link-dest=$LATEST_COMPLETE

/sbin/btrfs subvolume snapshot -r $LOCAL_DIR $LOCAL_DIR/backup-snapshot

rsync -e "ssh -i $SSH_KEY" -a --stats --delete --partial --rsync-path=/opt/bin/rsync $LINK_DEST_OPT $LOCAL_DIR/backup-snapshot/Everything $REMOTE_HOST:$REMOTE_DIR/partial-$TIMESTAMP/ && ssh -i $SSH_KEY $REMOTE_HOST mv $REMOTE_DIR/partial-$TIMESTAMP $REMOTE_DIR/complete-$TIMESTAMP

ssh -i $SSH_KEY $REMOTE_HOST '/opt/local/bin/purge-decay '$REMOTE_DIR'/complete-*'

rsync -e "ssh -i $SSH_KEY" -a --stats --delete --partial --rsync-path=/opt/bin/rsync $LOCAL_DIR/backup-snapshot/TimeMachine $REMOTE_HOST:$REMOTE_DIR/

/sbin/btrfs subvolume delete $LOCAL_DIR/backup-snapshot

ssh -i $SSH_KEY $REMOTE_HOST df -h | grep /mnt/eSata
