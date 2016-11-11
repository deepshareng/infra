#!/bin/bash

TIME=$(date +%M%H%d%m%y)

NSQL_DIR=/data/mongo-nsqlbackup/nsql

NSQL_DB_BACKUP_DIR=deepstats_day_backup_${TIME}
NSQL_DB_BACKUP_TAR=deepstats_day_backup_${TIME}.tar.gz


# mongodb backup for db nsql
[ ! -d "$NSQL_DIR" ] && mkdir -p $NSQL_DIR

cd $NSQL_DIR

# data backup
mongodump -h 10.100.10.231 -d deepstats_day_backup -o $NSQL_DB_BACKUP_DIR

# tar dir
tar czf $NSQL_DB_BACKUP_TAR $NSQL_DB_BACKUP_DIR

# upload nsql tar to azure storage
blobxfer prodbackup production-nsq-backup --upload $NSQL_DB_BACKUP_TAR --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# delete
rm -rf $NSQL_DB_BACKUP_TAR $NSQL_DB_BACKUP_DIR
