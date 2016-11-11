#!/bin/bash

T_1=$(date +%Y%m%d)
T_2=$(date +%Y%m%d%H%M)
T_3=$(date +%Y%m%d -d '7 days ago')

NSQL_LIST_1=NSQL_LIST
NSQL_LIST_2=NSQL_LIST_NEW

DBNAME_1=deepdash
DBNAME_2=oauth
DBNAME_3=deepstats

DIR_0=/data
DIR_1=${DIR_0}/${T_1}
DIR_2=${DIR_0}/${T_3}
DIR_3=${DIR_1}/${DBNAME_1}
DIR_4=${DIR_1}/${DBNAME_2}
DIR_5=${DIR_1}/${DBNAME_3}

DBNAME_5=${DBNAME_1}.${T_2}.tar.gz
DBNAME_6=${DBNAME_2}.${T_2}.tar.gz
DBNAME_7=${DBNAME_3}.${T_2}.tar.gz

[ -d ${DIR_2} ] && rm -rf ${DIR_2}
[ ! -d ${DIR_1} ] && mkdir -p ${DIR_1}
[ ! -d ${DIR_3} ] && mkdir -p ${DIR_3}
[ ! -d ${DIR_4} ] && mkdir -p ${DIR_4}
[ ! -d ${DIR_5} ] && mkdir -p ${DIR_4}
[ ! -d ${DIR_6} ] && mkdir -p ${DIR_4}

cd ${DIR_1}

# deepdash backup
mongodump --host 10.100.30.63 --port 30063 -d ${DBNAME_1} -o ${DIR_3}
# deepdash zip
tar czf ${DBNAME_5} ${DBNAME_1}
# deepdash upload to azure
blobxfer prodbackup production-mongo-backup ${DBNAME_5} --upload --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# oauth backup
mongodump --host 10.100.30.63 --port 30063 -d ${DBNAME_2} -o ${DIR_4}
# oauth zip
tar czf ${DBNAME_6} ${DBNAME_2}
# oauth upload to azure
blobxfer prodbackup production-mongo-backup ${DBNAME_6} --upload --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# deepstats backup
mongodump --host 10.100.30.63 --port 30063 -d ${DBNAME_3} -o ${DIR_5}
# deepstats  zip
tar czf ${DBNAME_7} ${DBNAME_3}
# deepstats upload to azure
blobxfer prodbackup production-mongo-backup ${DBNAME_7} --upload --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==

# deepstats nsq backup
[ -f ${NSQL_LIST_1} ] && rm -f ${NSQL_LIST_1}
[ -f ${NSQL_LIST_2} ] && rm -f ${NSQL_LIST_2}
# deepstats NSQL_LIST download
blobxfer prodbackup production-nsq-backup . --download --remoteresource ${NSQL_LIST_1} --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==
# deepstats NSQL_LIST_NEW update
DBS=$(mongo --host 10.100.30.70 --eval "printjson(db.adminCommand('listDatabases'))"|grep -w name|awk -F \" '{print $(NF-1)}'|grep deepstats|sort -n -t '_' -k 3)
for DB in $DBS;do
  COLLS=$( mongo --host 10.100.30.70 $DB --eval "printjson(db.getCollectionNames())"|grep coll|awk -F \" '{print $2}'|sort)
  for CL in $COLLS;do
    echo "$DB,$CL" >> ${NSQL_LIST_2}
  done
done
# deepstats nsq check and update
for LINE in `cat ${NSQL_LIST_2}`;do
  if `grep -q ${LINE} ${NSQL_LIST_1}`;then
    continue
  fi

  DB_NAME=$(echo ${LINE}|awk -F \, '{print $1}')
  DB_COLL=$(echo ${LINE}|awk -F \, '{print $2}')
  DB_COLL_TAR=${DB_NAME}.${DB_COLL}.${T_2}.tar.gz

  mongodump --host 10.100.30.70 --port 27017 -d ${DB_NAME} -c ${DB_COLL} -o ${DB_NAME}
  tar czf $DB_COLL_TAR ${DB_NAME}/${DB_NAME}/${DB_COLL}*

  blobxfer prodbackup production-nsq-backup ${DB_COLL_TAR} --upload --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==
done

mv ${NSQL_LIST_2} ${NSQL_LIST_1}
blobxfer prodbackup production-nsq-backup ${NSQL_LIST_1} --upload --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==
