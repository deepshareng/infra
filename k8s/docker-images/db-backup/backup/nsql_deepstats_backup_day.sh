#!/bin/bash

TIME_D=$(date +%M%H%d%m%y)

NSQL_DIR=/data/mongo-nsqlbackup/nsql

# mongodb backup for db nsql
[ ! -d "$NSQL_DIR" ] && mkdir -p $NSQL_DIR

cd $NSQL_DIR

# db get
DB=$(mongo --host 10.100.10.231 --eval "printjson(db.adminCommand('listDatabases'))"|grep -w name|awk -F \" '{print $(NF-1)}'|grep deepstats_backup|sort -n -t '_' -k 3|tail -1)

# db_var
NSQL_DD_BACKUP_DIR=$DB_${TIME}
NSQL_DD_BACKUP_TAR=$DB_${TIME}.tar.gz

# data backup
mongodump -h 10.100.10.231 -d $DB -o $NSQL_DD_BACKUP_DIR

# tar dir
tar czf $NSQL_DD_BACKUP_TAR $NSQL_DD_BACKUP_DIR

# upload nsql tar to azure storage
blobxfer prodbackup production-nsq-backup --upload $NSQL_DD_BACKUP_TAR --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# delete
rm -rf $NSQL_DD_BACKUP_TAR $NSQL_DD_BACKUP_DIR
