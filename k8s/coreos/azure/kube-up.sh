#! /bin/bash
if [[ $# < 1 ]]
then
	echo './kube-up.sh [options]'
	echo '  -e --env <testing|production> setup kubernetes cluster for testing or production environment'
	echo '  --help show this information'
	exit 1
fi
while [[ $# > 1 ]]
do
key="$1"

case $key in
    -e|--env)
	ENV="$2"
	if [ ${ENV} = 'production' ]
	then
		MASTER_HOST=k8s.fds.so:6443
		echo 'constructing kubernetes cluster for production'
	else
		MASTER_HOST=k8s-test.fds.so:6443
		echo 'constructing kubernetes cluster for testing'
	fi
    shift # past argument
    ;;
    *)
	echo 'wrong argument, use ./kube-up.sh --help for more information.'
    exit 1
    ;;
esac
shift # past argument or value
done

echo 'ENV='$ENV
# mkdir -p ${ENV}-CA
# if [ ! -f ${ENV}-CA/ca-key.pem ]
# then
# 	echo 'generating CA and certification keys in '${ENV}'-CA/'
# 	echo 'generating root CA...'
# 	openssl genrsa -out ${ENV}-CA/ca-key.pem 2048
# 	openssl req -x509 -new -nodes -key ${ENV}-CA/ca-key.pem -days 10000 -out ${ENV}-CA/ca.pem -subj "/CN=kube-ca"
# 	echo 'generating apiserver-key...'
# 	openssl genrsa -out ${ENV}-CA/apiserver-key.pem 2048
# 	openssl req -new -key ${ENV}-CA/apiserver-key.pem -out ${ENV}-CA/apiserver.csr -subj "/CN=kube-apiserver" -config ./openssl.cnf
# 	openssl x509 -req -in ${ENV}-CA/apiserver.csr -CA ${ENV}-CA/ca.pem -CAkey ${ENV}-CA/ca-key.pem -CAcreateserial -out ${ENV}-CA/apiserver.pem -days 3650 -extensions v3_req -extfile ./openssl.cnf
# 	echo 'generating worker-key...'
# 	openssl genrsa -out ${ENV}-CA/worker-key.pem 2048
# 	openssl req -new -key ${ENV}-CA/worker-key.pem -out ${ENV}-CA/worker.csr -subj "/CN=kube-worker"
# 	openssl x509 -req -in ${ENV}-CA/worker.csr -CA ${ENV}-CA/ca.pem -CAkey ${ENV}-CA/ca-key.pem -CAcreateserial -out ${ENV}-CA/worker.pem -days 3650
# 	echo 'generating admin-key...'
# 	openssl genrsa -out ${ENV}-CA/admin-key.pem 2048
# 	openssl req -new -key ${ENV}-CA/admin-key.pem -out ${ENV}-CA/admin.csr -subj "/CN=kube-admin"
# 	openssl x509 -req -in ${ENV}-CA/admin.csr -CA ${ENV}-CA/ca.pem -CAkey ${ENV}-CA/ca-key.pem -CAcreateserial -out ${ENV}-CA/admin.pem -days 3650
# 	echo 'uploading CA and keys...'
# 	azure storage blob upload --quiet --container=keys --file=${ENV}-CA/ca.pem
# 	azure storage blob upload --quiet --container=keys --file=${ENV}-CA/apiserver.pem
# 	azure storage blob upload --quiet --container=keys --file=${ENV}-CA/apiserver-key.pem
# 	azure storage blob upload --quiet --container=keys --file=${ENV}-CA/worker-key.pem
# 	azure storage blob upload --quiet --container=keys --file=${ENV}-CA/worker.pem
# 	azure storage blob upload --quiet --container=keys --file=./worker-kubeconfig.yaml
# else
# 	echo 'CA and certification keys were already there.'
# fi

echo 'now starting to build kubernetes cluster...'
./create-kubernetes-cluster.js 0
# echo 'we need nodes from node-00 to node-04 at least'
# echo 'labeling node-00 for nfs server'
# kubectl label node node-00 tag=nfs 
# echo 'labeling node-01, node-02, node-03 for frontend in production environment'
# kubectl label node node-01,node-02,node-03 tag=frontend
# echo 'labeling node-04 for frontend in staging environment'
# kubectl label node node-04 tag=frontend-staging
# echo 'call cluster-init.yaml to create namespace, daemonset. install dns server, install nfs server, create pv and pvc'
# kubectl create -f ./cluster-init.yaml
# echo 'create daemonset for nginx'