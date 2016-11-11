# 当前Cluster的结构
由于Azure的一个cloud service只能有一个公网IP，并且一个cloud service下面只能有50台虚拟机，所以我们将cluster建在多个cloud service下。
根据不同的功能模块，我们将整个cluster分成如下几个区域
1. qdk-m1 cluster中的master和etcd节点
2. qdk-z1 deepshare core
3. qdk-z2 ni
4. qdk-z3 kube-sys and monitoring system
5. qdk-z4 deepshare nginx for deepshare.io and dashboard.deepshare.io

# 在现有的cluster里面申请新节点
在申请新节点之前，确保azure-cli已经安装好，并且通过｀azure import｀导入了azure账户信息
首先设置环境变量｀export AZ_VM_SIZE=Large｀，说明虚拟机的大小。
然后，运行｀./scale-kubernetes-cluster.js ./output/qdk_deployment.yml qdk-z1 node 3｀，就可以申请新的节点了。
参数说明：
1. ./output/qdk_deployment.yml 这个是用来记录目前cluster的部署情况的文件
2. qdk-z1 说明在哪个区域中申请新的节点
3. node 说明申请的是master节点还是worker节点
4. 3 说明需要申请多少台虚拟机