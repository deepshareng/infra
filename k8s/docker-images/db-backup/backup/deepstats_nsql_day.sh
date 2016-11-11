#!/bin/bash

TIME=$(date +%M%H%d%m%y)

NSQL_DIR=/data/mongo-nsqlbackup
NSQL_BK_DIR=$NSQL_DIR/nsql
NSQL_LIST=NSQL_LIST
NSQL_LIST_NEW=NSQL_LIST_NEW

# BASE
[ ! -d "$NSQL_DIR" ] && mkdir -p $NSQL_DIR
[ ! -d "$NSQL_BK_DIR" ] && mkdir -p $NSQL_BK_DIR

cd $NSQL_DIR

# download
[ -f $NSQL_LIST ] && rm -f $NSQL_LIST
[ -f $NSQL_LIST_NEW ] && rm -f $NSQL_LIST_NEW  && touch $NSQL_LIST_NEW

blobxfer prodbackup production-nsq-backup . --download --remoteresource $NSQL_LIST --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# NSQL_LIST
DBS=$(mongo --host 10.100.10.231 --eval "printjson(db.adminCommand('listDatabases'))"|grep -w name|awk -F \" '{print $(NF-1)}'|grep deepstats|sort -n -t '_' -k 3)

for DB in $DBS;do
  COLLS=$( mongo --host 10.100.10.231 $DB --eval "printjson(db.getCollectionNames())"|grep coll|awk -F \" '{print $2}'|sort)
  for CL in $COLLS;do
    echo "$DB,$CL" >> $NSQL_LIST_NEW
  done
done

for CO in `cat $NSQL_LIST_NEW|awk -F \, '{print $2}'|sort|uniq`;do
  for co in 'coll2016200' 'coll2016201' 'coll2016203' 'coll2016204' 'coll2016207';do
    [ $co != $CO ] && continue

    NUM=$(grep $co $NSQL_LIST|wc -l)

    [ $NUM -eq 2 ] && continue


    mongodump -h 10.100.10.231 -d deepstats_day_backup -c $co -o $NSQL_BK_DIR

    tar czf ${co}_${TIME}_deepstats_day_backup.tar.gz $NSQL_BK_DIR

    blobxfer prodbackup production-nsq-backup ${co}_${TIME}_deepstats_day_backup.tar.gz --upload --pageblob --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

    rm -rf ${co}_${TIME}_deepstats_day_backup.tar.gz $NSQL_BK_DIR


    mongodump -h 10.100.10.231 -d deepstats_backup_20162 -c $co -o $NSQL_BK_DIR

    tar czf ${co}_${TIME}_deepstats_backup_20162.tar.gz $NSQL_BK_DIR

    blobxfer prodbackup production-nsq-backup ${co}_${TIME}_deepstats_day_backup.tar.gz --upload --pageblob --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

    rm -rf ${co}_${TIME}_deepstats_backup_20162.tar.gz $NSQL_BK_DIR

  done

  if `grep -q $CO $NSQL_LIST`;then
    continue
  fi

  DB_NAME=$(grep $CO $NSQL_LIST_NEW|awk -F \, '{print $1}')
  DB_COLL=${CO}
  DB_COLL_TAR=${CO}_${TIME}.tar.gz

  mongodump -h 10.100.10.231 -d $DB_NAME -c $DB_COLL -o $NSQL_BK_DIR

  tar czf $DB_COLL_TAR $NSQL_BK_DIR

  blobxfer prodbackup production-nsq-backup $DB_COLL_TAR --upload --pageblob --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

  rm -rf $DB_COLL_TAR $NSQL_BK_DIR

done

mv $NSQL_LIST_NEW $NSQL_LIST
blobxfer prodbackup production-nsq-backup $NSQL_LIST --upload --pageblob --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==
