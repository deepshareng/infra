1. 创建和挂载高级存储:
```bash
azure storage account create "deepsharedata" -l "China North" --type GRS --description "DeepShare data center"
azure storage account list
```

2.挂载高级存储磁盘:
```bash
azure vm disk attach-new qdk-z6-node-00 1023 https://deepsharedata.blob.core.chinacloudapi.cn/deepsharedb/deepshareDB1.vhd
azure vm disk attach-new qdk-z6-node-01 1023 https://deepsharedata.blob.core.chinacloudapi.cn/deepsharedb/deepshareDB2.vhd
azure vm disk attach-new qdk-z6-node-02 1023 https://deepsharedata.blob.core.chinacloudapi.cn/deepsharedb/deepshareDB3.vhd
```

3.到节点进行磁盘格式化:  
* 格式化  
```bash
sudo fdisk -l
sudo mkfs.ext4 /dev/sdc
```
* 设置挂载点  
```bash
cd /etc/systemd/system
sudo vim mnt-data.mount
[Unit]
Description = Mount /dev/sdc to /mnt/data

[Mount]
What=/dev/sdc
Where=/mnt/data
Type=ext4

[Install]
WantedBy = multi-user.target

sudo systemctl enable --now mnt-data.mount
```

4.到节点创建mongo存储目录:
```bash
cd /mnt/data
sudo mkdir -p mongo/{30001,30002,30003,30011,30012,30013,30021,30022,30023,config1,config2,config3,mongos}
```

5.对已经创建好的YAML文件执行:
```bash
kubectl create -f db.namespace.yaml
kubectl create -f mongo.shard1.rc.yaml
kubectl create -f mongo.shard2.rc.yaml
kubectl create -f mongo.shard3.rc.yaml
kubectl create -f mongo.config.rc.yaml
kubectl create -f mongo.mongos.rc.yaml
```

6.对启动后的sharding初始化副本集:
```bash
mongo --host 10.100.30.1  --port 30001  
mongo --host 10.100.30.12 --port 30012  
mongo --host 10.100.30.23 --port 30023  
```
```bash
config={_id: 'shard1', members: [{_id: 0, host: '10.100.30.1:30001'}, {_id: 1, host: '10.100.30.2:30002'}, {_id: 2, host: '10.100.30.3:30003'}]}  
rs.initiate(config);  
config={_id: 'shard2', members: [{_id: 0, host: '10.100.30.11:30011'}, {_id: 1, host: '10.100.30.12:30012'}, {_id: 2, host: '10.100.30.13:30013'}]}  
rs.initiate(config);  
config={_id: 'shard3', members: [{_id: 0, host: '10.100.30.21:30021'}, {_id: 1, host: '10.100.30.22:30022'}, {_id: 2, host: '10.100.30.23:30023'}]}
rs.initiate(config);    
```

7.登录到任意一台mongos上,进行sharding:
```bash
mongo --host 10.100.30.61 --port 30061

use admin
db.runCommand({addshard:"shard1/10.100.30.1:30001,10.100.30.2:30002,10.100.30.3:30003",name:"shard1"})
db.runCommand({addshard:"shard2/10.100.30.11:30011,10.100.30.12:30012,10.100.30.13:30013",name:"shard2"})  
db.runCommand({addshard:"shard3/10.100.30.21:30021,10.100.30.22:30022,10.100.30.23:30023",name:"shard3"})  

db.runCommand({listshards:1})
db.printShardingStatus()
```

8.登录到任意一台mongos上,对数据库进行sharding
```bash
use admin
db.runCommand({enablesharding:"deepdash"});  
```

9.登录到任意一台mongos上,对collection进行sharding:
```bash
use dbname
db.collection.getIndexes()                                         //获取索引(注意:此索引不会变！！！)

use admin
sh.shardCollection("deepdash.usercoll",{"_id":"1"})                //根据索引进行分片
db.runCommand({shardCollection:"deepdash.appcoll",key:{"_id":"1"}) //根据索引进行分片
```
