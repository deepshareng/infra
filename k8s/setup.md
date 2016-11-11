# Kubernetes on Azure with Ubuntu and Flannel
In this guide we will talk about how to deploy a Kubernetes cluster to Azure cloud.

## Prerequisite
- Azure account.
- [Install Azure CLI](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/). Add Azure account in.


## VM Definition
The types of VM we tested:
- Ubuntu 14.04 LTS Server

### Create VM On Azure


Create a cloud service:
```
azure service create ${your_service}

```

Verify cloud service is created:
```
azure service list
```

Create VM:
```
azure vm create --ssh=22 --userName=${username} --password=${password} \
                --vm-name=${vm_name} --connect=${your_service} \
                --vm-size="{Small | Medium | Large}" \
                ${image: Find An Ubuntu Image}
```


Verify VM is created:
```
azure vm show ${vm_name}
azure vm list
```


All VMs created under a service share the same public DNS name entry.
As a result, each has a different SSH port.
However, each VM has a private IP and can talk to the other within
the same cloud service.

## Master Node
[Install Docker](http://docs.docker.com/linux/step_one/).

Install dependencies:
```
sudo apt-get install aufs-tools bridge-utils
```

Install k8s by running our [master.sh](master.sh):
```
sudo K8S_VERSION=${your_k8s_version} bash master.sh
```

Verify by using kubectl:
```
kubectl get nodes
```
And you should see one node is listed.

Check the IP address and write it down for worker:
```
azure vm show ${master_node_name}
```

## Worker Node
[Install Docker](http://docs.docker.com/linux/step_one/).

Install dependencies:
```
sudo apt-get install aufs-tools bridge-utils
```

Install k8s by running our [worker.sh](worker.sh):
```
sudo K8S_VERSION=${your_k8s_version} MASTER_IP=${master_ip} bash worker.sh
```

Verify by using kubectl in master node:
```
kubectl get nodes
```
And you should see the new worker node is listed.
