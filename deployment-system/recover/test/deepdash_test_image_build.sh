#!/bin/bash



VERSION=$(date +%Y%m%d%H%M)

CODE_DIR=/mnt/test/deepdash
REPOSITORY_ADDR=r.fds.so:5000

cd $CODE_DIR;  sudo docker build -t  $REPOSITORY_ADDR/deepdash-test:$VERSION .


DS2_VERSION=`sudo docker images |grep deepdash-test |awk '{print $2}'|sort -n |tail -1`


if [ "$DS2_VERSION" == "$VERSION" ]; then
        sudo docker push $REPOSITORY_ADDR/deepdash-test:$VERSION
else
        echo false
fi




# scallout pods
ssh -p 2201 core@42.159.27.69 -C 'bash  /home/core/deployment/deepdash_production.sh'
