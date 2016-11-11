#!/bin/bash



VERSION=$(date +%Y%m%d%H%M)

CODE_DIR=/mnt/staging/deepshare2
REPOSITORY_ADDR=r.fds.so:5000

cd $CODE_DIR;  sudo docker build -f Dockerfile_apitest -t  $REPOSITORY_ADDR/deepshare2-apitest:$VERSION .


DS2_VERSION=`sudo docker images |grep deepshare2-apitest |awk '{print $2}'|sort -n |tail -1`


if [ "$DS2_VERSION" == "$VERSION" ]; then
        sudo docker push $REPOSITORY_ADDR/deepshare2-apitest:$VERSION
else
        echo false
fi




# scallout pods
ssh -p 2201 core@fds.so -C 'bash  /home/core/deployment/deepshare2-apitest.sh'
