#!/bin/bash

T_1=$(date +%Y%m%d)
T_2=$(date +%Y%m%d%H%M)
T_3=$(date +%Y%m%d -d '7 days ago')

DBNAME_1=redis-dsusage-data-6380
DBNAME_2=redis-data-7000

DIR_0=/data
DIR_1=${DIR_0}/${T_1}
DIR_2=${DIR_0}/${T_3}
DIR_3=${DIR_1}/${DBNAME_1}
DIR_4=${DIR_1}/${DBNAME_2}

DBNAME_3=${DBNAME_1}.${T_2}.tar.gz
DBNAME_4=${DBNAME_2}.${T_2}.tar.gz

[ -d ${DIR_2} ] && rm -rf ${DIR_2}
[ ! -d ${DIR_1} ] && mkdir -p ${DIR_1}
[ ! -d ${DIR_3} ] && mkdir -p ${DIR_3}
[ ! -d ${DIR_4} ] && mkdir -p ${DIR_4}


cd ${DIR_1}

# redis-dsusage-data-6380 backup
scp -i /opt/new-node.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no core@172.16.0.12:/var/lib/docker/redis-dsusage-data-6380/* ${DIR_3}

# redis-dsusage-data-6380 zip
tar czf ${DBNAME_3} ${DBNAME_1}

# redis-dsusage-data-6380 upload to azure
blobxfer prodbackup production-redis-backup ${DBNAME_3} --upload --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==


# redis-data-7000 backup
mkdir -p ${DIR_4}/{7004,7005,7006}
scp -i /opt/new-node.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no core@172.16.6.4:/mnt/data/redis/7004/*  ${DIR_4}/7004
scp -i /opt/new-node.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no core@172.16.6.5:/mnt/data/redis/7005/*  ${DIR_4}/7005
scp -i /opt/new-node.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no core@172.16.6.6:/mnt/data/redis/7006/*  ${DIR_4}/7006

# redis-data-7000 zip
tar czf ${DBNAME_4} ${DBNAME_2}

# redis-data-7000 upload to azure
blobxfer prodbackup production-redis-backup ${DBNAME_4} --upload --managementep core.chinacloudapi.cn --endpoint core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==
