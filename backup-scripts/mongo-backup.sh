#!/bin/bash

DEEPDASH_DIR=/data/mongo-dashboard/deepdash
OAUTH_DIR=/data/mongo-dashboard/oauth


# mongodb backup for db dashboard-deepdash
if [ ! -d "$DEEPDASH_DIR" ]; then
  mkdir -p $DEEPDASH_DIR
fi 

cd $DEEPDASH_DIR;  /usr/bin/mongodump -h 10.100.1.117 -d deepdash -o dashboard-backup-deepdash-$(date +%d%m%y); tar czvf dashboard-deepdash-$(date +%d%m%y).tar.gz *
# upload dashboard-backup file to azure storage
cd $DEEPDASH_DIR; blobxfer prodbackup production-mongo-backup --upload *.gz --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbx
bkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==
rm -rf $DEEPDASH_DIR/*



# mongodb backup for db dashboard-deepdash
if [ ! -d "$OAUTH_DIR" ]; then
  mkdir -p $OAUTH_DIR
fi


cd $OAUTH_DIR;  /usr/bin/mongodump -h 10.100.1.117 -d deepdash -o dashboard-backup-oauth-$(date +%d%m%y); tar czvf dashboard-oauth-$(date +%d%m%y).tar.gz *
# upload dashboard-backup file to azure storage
cd $OAUTH_DIR; blobxfer prodbackup production-mongo-backup --upload *.gz --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkA
i71x942BbK+1VPjbsb3Pp4XSnNgOL0w==
rm -rf $OAUTH_DIR/*


cd /data/mongo-nsqbackup;   /usr/bin/mongodump -h 10.100.10.231  -o  nsqlbackup-$(date +%d%m%y); tar czvf nsqlbackup-$(date +%d%m%y).tar.gz nsqlbackup-*
# upload nsq-backup-data file to azure storage
blobxfer prodbackup production-mongo-backup --upload /data/mongo-nsqbackup/*.gz --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfU
bxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==
rm -rf /data/mongo-nsqbackup/*
