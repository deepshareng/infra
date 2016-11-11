#!/bin/bash

TIME=$(date +%M%H%d%m%y)

DEEPDASH_DIR=/data/mongo-dashboard/deepdash
DEEPDASH_BACKUP_DIR=dashboard-backup-deepdash-${TIME}
DEEPDASH_BACKUP_TAR=dashboard-backup-deepdash-${TIME}.tar.gz

OAUTH_DIR=/data/mongo-dashboard/oauth
OAUTH_BACKUP_DIR=dashboard-backup-oauth-${TIME}
OAUTH_BACKUP_TAR=dashboard-backup-oauth-${TIME}.tar.gz

NSQL_DIR=/data/mongo-nsqlbackup/nsql
NSQL_BACKUP_DIR=nsql-backup-${TIME}
NSQL_BACKUP_TAR=nsql-backup-${TIME}.tar.gz


# mongodb backup for db dashboard-deepdash
[ ! -d "$DEEPDASH_DIR" ] && mkdir -p $DEEPDASH_DIR

cd $DEEPDASH_DIR

# data backup
mongodump -h 10.100.1.117 -d deepdash -o $DEEPDASH_BACKUP_DIR

# tar dir
tar czf $DEEPDASH_BACKUP_TAR $DEEPDASH_BACKUP_DIR

# upload deepdash tar to azure storage
blobxfer prodbackup production-mongo-backup --upload $DEEPDASH_BACKUP_TAR --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# delete 
rm -rf $DEEPDASH_DIR


# mongodb backup for db dashboard-oauth
[ ! -d "$OAUTH_DIR" ] && mkdir -p $OAUTH_DIR

cd $OAUTH_DIR

# data backup
mongodump -h 10.100.1.117 -d oauth -o $OAUTH_BACKUP_DIR

# tar dir
tar czf $OAUTH_BACKUP_TAR $OAUTH_BACKUP_DIR

# upload oauth tar to azure storage
blobxfer prodbackup production-mongo-backup --upload $OAUTH_BACKUP_TAR --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# delete
rm -rf $OAUTH_DIR


# mongodb backup for db nsql
[ ! -d "$NSQL_DIR" ] && mkdir -p $NSQL_DIR

cd $NSQL_DIR

# data backup
mongodump -h 10.100.10.231 -o $NSQL_BACKUP_DIR

# tar dir
tar czf $NSQL_BACKUP_TAR $NSQL_BACKUP_DIR

# upload nsql tar to azure storage
blobxfer prodbackup production-nsq-backup --upload $NSQL_BACKUP_TAR --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# delete
rm -rf $NSQL_DIR
