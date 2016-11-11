#!/bin/bash

TIME=$(date +%M%H%d%m%y)

REDIS_DIR=/data/redis-backup/redis-data
REDIS_BACKUP_DIR=redis-data-7000-${TIME}
REDIS_BACKUP_TAR=redis-data-7000-${TIME}.tar.gz

REDIS_DSUSAGE_DIR=/data/redis-backup/redis-dsusage
REDIS_DSUSAGE_BACKUP_DIR=redis-dsusage-data-6380-${TIME}
REDIS_DSUSAGE_BACKUP_TAR=redis-dsusage-data-6380-${TIME}.tar.gz


# redis backup for redis-data-7000
[ ! -d "$REDIS_DIR" ] && mkdir -p $REDIS_DIR

cd $REDIS_DIR

# mkdir dir
mkdir -p $REDIS_BACKUP_DIR

# data backup
scp -i /opt/new-node.pem core@172.16.0.16:/var/lib/docker/redis-data-7000/* $REDIS_BACKUP_DIR

# tar dir
tar czf $REDIS_BACKUP_TAR $REDIS_BACKUP_DIR

# upload redis-data-7000  tar to azure storage
blobxfer prodbackup production-redis-backup --upload $REDIS_BACKUP_TAR --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# delete
rm -rf $REDIS_DIR


# redis backup for redis-dsusage-data-6380
[ ! -d "$REDIS_DSUSAGE_DIR" ] && mkdir -p $REDIS_DSUSAGE_DIR

cd $REDIS_DSUSAGE_DIR

# mkdir dir
mkdir -p $REDIS_DSUSAGE_BACKUP_DIR

# data backup
scp -i /opt/new-node.pem core@172.16.0.12:/var/lib/docker/redis-dsusage-data-6380/* $REDIS_DSUSAGE_BACKUP_DIR

# tar dir
tar czf $REDIS_DSUSAGE_BACKUP_TAR $REDIS_DSUSAGE_BACKUP_DIR

# upload redis-dsusage-data-6380 tar to azure storage
blobxfer prodbackup production-redis-backup --upload $REDIS_DSUSAGE_BACKUP_TAR --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# delete
rm -rf $REDIS_DSUSAGE_DIR
