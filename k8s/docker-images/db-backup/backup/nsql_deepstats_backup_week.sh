#!/bin/bash

TIME=$(date +%M%H%d%m%y)

NSQL_DIR=/data/mongo-nsqlbackup/nsql

# mongodb backup for db nsql
[ ! -d "$NSQL_DIR" ] && mkdir -p $NSQL_DIR

cd $NSQL_DIR

# db get
DBS=$(mongo --host 10.100.10.231 --eval "printjson(db.adminCommand('listDatabases'))"|grep -w name|awk -F \" '{print $(NF-1)}'|grep deepstats_backup|sort -n -t '_' -k 3)
DB=$(mongo --host 10.100.10.231 --eval "printjson(db.adminCommand('listDatabases'))"|grep -w name|awk -F \" '{print $(NF-1)}'|grep deepstats_backup|sort -n -t '_' -k 3|tail -1)

# data backup
for db in $DBS;do
  [ $db == $DB ] && continue

  NSQL_DS_BACKUP_DIR=$db_${TIME}
  NSQL_DS_BACKUP_TAR=$db_${TIME}.tar.gz

  mongodump -h 10.100.10.231 -d $db -o $NSQL_DS_BACKUP_DIR

  tar czf $NSQL_DS_BACKUP_TAR $NSQL_DS_BACKUP_DIR

  blobxfer prodbackup production-nsq-backup --upload $NSQL_DS_BACKUP_TAR --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

  rm -rf $NSQL_DS_BACKUP_TAR $NSQL_DS_BACKUP_DIR
done
