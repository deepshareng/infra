kubernetes on Azure with CoreOS and [Flannel](https://github.com/coreos/flannel)
---------------------------------------------------------------

**Table of Contents**

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Let's go!](#lets-go)
- [Scaling](#scaling)
- [Tear down...](#tear-down)

## Introduction

In this guide I will demonstrate how to deploy a Kubernetes cluster to Azure cloud. You will be using CoreOS with Flannel. The purpose of this guide is to provide an out-of-the-box implementation that can ultimately be taken into production with little change. It will demonstrate how to provision a dedicated Kubernetes master and nodes, and show how to scale the cluster with ease.

### Prerequisites

1. You need an Azure account.

## Let's go!

To get started, you need to checkout the code:

```sh
git clone https://github.com/MISingularity/infra
cd infra/k8s/coreos/azure/
```

You will need to have [Node.js installed](http://nodejs.org/download/) on you machine. If you have previously used Azure CLI, you should have it already.

First, you need to install some of the dependencies with

```sh
npm install
```

Now, all you need to do is:

```sh
./azure-login.js -u <your_username>
```
If you are using azuer china cloud, you need change some env variable from its default value.
```
source ./set-env-cn.sh
```
Then, you can install kubernetes
```
./create-kubernetes-cluster.js
```

This script will provision a cluster suitable for production use: 1 kubernetes master and 3 kubernetes nodes. The `master-00` VM will be the master, your work loads are only to be deployed on the nodes, `node-00`, `node-01` and `node-02`. Initially, all VMs are single-core, to ensure a user of the free tier can reproduce it without paying extra. I will show how to add more bigger VMs later.

Once the creation of Azure VMs has finished, you should see the following:

```console
...
azure_wrapper/info: Saved SSH config, you can use it like so: `ssh -F  ./output/k8s-fl_1c1496016083b4_ssh_conf <hostname>`
azure_wrapper/info: The hosts in this deployment are:
 [ 'master-00', 'node-00', 'node-01', 'node-02' ]
azure_wrapper/info: Saved state into `./output/k8s-fl_1c1496016083b4_deployment.yml`
```

Let's login to the master node like so:

```sh
ssh -F  ./output/kube_1c1496016083b4_ssh_conf master-00
```

> Note: config file name will be different, make sure to use the one you see.

Check there are 3 nodes in the cluster:

```console
core@master ~ $ kubectl get nodes
NAME      LABELS                           STATUS
172.18.0.5   kubernetes.io/hostname=172.18.0.5   Ready
172.18.0.6   kubernetes.io/hostname=172.18.0.6   Ready
172.18.0.12   kubernetes.io/hostname=172.18.0.12   Ready
```
## Scaling

Two single-core nodes are certainly not enough for a production system of today. Let's scale the cluster by adding a couple of bigger nodes.

You will need to open another terminal window on your machine and go to the same working directory (e.g. `~/infra/k8s/coreos/azure/`).

First, lets set the size of new VMs:

```sh
export AZ_VM_SIZE=Large
```

Now, run scale script with state file of the previous deployment and number of nodes to add:

```console
user@my-workstation ~ $ ./scale-kubernetes-cluster.js ./output/k8s-fl_1c1496016083b4_deployment.yml 2
...
azure_wrapper/info: Saved SSH config, you can use it like so: `ssh -F  ./output/k8s-fl_8f984af944f572_ssh_conf <hostname>`
azure_wrapper/info: The hosts in this deployment are:
 [ 'master-00',
  'node-00',
  'node-01',
  'node-02',
  'node-03',
  'node-04' ]
azure_wrapper/info: Saved state into `./output/k8s-fl_8f984af944f572_deployment.yml`
```

> Note: this step has created new files in `./output`.

Back on `master-00`:

```console
core@master ~ $ kubectl get nodes
NAME      LABELS                           STATUS
172.18.0.5   kubernetes.io/hostname=172.18.0.5   Ready
172.18.0.6   kubernetes.io/hostname=172.18.0.6   Ready
172.18.0.12   kubernetes.io/hostname=172.18.0.12   Ready
172.18.0.13   kubernetes.io/hostname=172.18.0.13   Ready
172.18.0.14   kubernetes.io/hostname=172.18.0.14   Ready
```
## Tear down...

If you don't wish care about the Azure bill, you can tear down the cluster. It's easy to redeploy it, as you can see.

```sh
./destroy-cluster.js ./output/k8s-fl_8f984af944f572_deployment.yml
```
> Note: make sure to use the _latest state file_, as after scaling there is a new one.

By the way, with the scripts shown, you can deploy multiple clusters, if you like :)
