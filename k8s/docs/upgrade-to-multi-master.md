# kubernetes升级
这次升级主要实现的改进是
1. 在5台master节点(兼做etcd cluster的节点)同时启动apiserver, scheduler以及controller manager组件, 消除master node只有一个的单点故障的问题
2. master上的apiserver, scheduler以及controller manager都通过kubelet来调起, 使得将来kubernetes的升级变得更加简单

# 主要步骤
## step 1: 检查vnet配置
在新的cluster中, 我们划分了几个不同的网段, 分别对应master区域以及worker区域集. worker区域集可以包含多个worker区域, 每个worker区域通常对应不同的产品, 例如kubernetes系统服务环境, deepshare生产环境, deepshare测试环境, ni生产环境, ni测试环境.

## step 2: 确认deployment.yaml的配置无误
我们把每个worker zone分配给不同的cloud service, 这样每个worker zone就有了一个internet ip, 这样我们的每个产品就不必共享同一个ip和nginx代理, 每次更新产品的nginx代理配置的时候会对其他的产品造成影响.

此外, 我们为每个cloud service绑定了一个availability set, 在同一个cloud service里面的机器会被配置到数据中心的不同的机柜中, 这样当azure在对数据中心进行维护的时候, 就不会出现一个产品中的几台机器一起被停掉的情况, 从而我们的服务也不会出现downtime了.

## step 3: 备份在master-00上的发布系统脚本
原来在master-00上放的发布系统的脚本需要先保存一下

## step 4: 停掉原cluster中的master-01, 但不要删除
停掉原来的节点是为了让cluster的内部ip释放掉, 从而在申请新节点的时候, 这个ip可以分配给新节点, 因为在etcd cluster的IP配置是放在fds.so的域名解析中的, 这样几个etcd cluster的ip就被固定下来了.

## step 5: 创建新版cluster的master-01
用事先写好的脚本申请一个新节点

## step 6: 将master-01上的etcd2加入原etcd cluster
当新节点启动以后, 需要进入新的节点中, 暂时将etcd2的配置改掉, etcd2的临时配置是:
```
[Service]
Environment="ETCD_DISCOVERY_SRV="
Environment="ETCD_NAME=qdk-m1-master-02"
Environment="ETCD_INITIAL_CLUSTER=7fc316e9b5b3ba98=http://master-04.fds.so:2380,qdk-m1-master-02=http://master-02.fds.so:2380,b1926d37389d869f=http://master-03.fds.so:2380,b32d5c54109cf744=http://master-01.fds.so:2380,cfadb0c6f738375a=http://master-00.fds.so:2380"
Environment="ETCD_INITIAL_CLUSTER_STATE=existing"
```
其中注意节点的名字和cluster里面已有的节点名字处理每个新增的节点的时候是变化的.

修改了etcd2的配置后,还需要执行以下操作:
1. 需要运行`sudo rm -r /var/lib/etcd2/member`, 删除现有etcd2的数据
2. `sudo systemctl daemon-reload`, 重新加载编辑过的etcd2配置
3. `sudo systemctl restart etcd2.service`, 重新启动etcd2.service

## step 7: 重复step4到step6直到所有master节点被升级到新版cluster
当我们将现有的master节点都替换掉后, 然后在新的节点上定义endpoint, 以便用户可以通过internet用kubectl来部署和配置.
至此,新的cluster就可以正式工作了
