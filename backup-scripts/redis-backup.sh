REDIS_DEEPSHARE_DIR=/data/redis-backup
REDIS_DSUSAGE_DIR=/data/redis-dsusage-backup

# redis-backup deepshare2 production machine
if [ ! -d "$REDIS_DEEPSHARE_DIR" ]; then
  mkdir -p $REDIS_DEEPSHARE_DIR
fi

cd $REDIS_DEEPSHARE_DIR scp -i /opt/new-node.pem  core@172.16.0.16:/var/lib/docker/redis-data-7000/* $REDIS_DEEPSHARE_DIR; tar czvf redis-backup-$(date +%d%M%y).tar.gz *

# upload redis backup-file to azure storage
blobxfer prodbackup production-redis-backup  --upload /data/redis-backup/*.tar.gz --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==
rm -rf $REDIS_DEEPSHARE_DIR/*

# redis-backup deepshare2 dsusage  machine
if [ ! -d "$REDIS_DSUSAGE_DIR" ]; then
  mkdir -p $REDIS_DSUSAGE_DIR
fi
cd $REDIS_DSUSAGE_DIR;  scp -i /opt/new-node.pem core@172.16.0.12:/var/lib/docker/redis-dsusage-data-6380/* $REDIS_DSUSAGE_DIR  &&  tar czvf redis-backup-dsuage-$(date +%d%M%y).tar.gz *

# upload redis dsusage backup-file to azure storage
blobxfer prodbackup production-redis-backup  --upload /data/redis-dsusage-backup/*.tar.gz --blobep core.chinacloudapi.cn --storageaccountkey PE0fJ1Vpa/IHasMjhpndbL9+2oSJpo/GwgTPw34zTS9/1CyOfUbxbkAi71x942BbK+1VPjbsb3Pp4XSnNgOL0w==
rm -rf $REDIR_DSUSAGE_DIR/*
