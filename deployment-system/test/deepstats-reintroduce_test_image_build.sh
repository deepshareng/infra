#!/bin/bash



VERSION=$(date +%Y%m%d%H%M)

CODE_DIR=/mnt/test/deepstats
REPOSITORY_ADDR=r.fds.so:5000


cd $CODE_DIR;  sudo docker build -f Dockerfile_reintroduce -t  $REPOSITORY_ADDR/deepstats-reintroduce-test:$VERSION .


DS2_VERSION=`sudo docker images |grep deepstats-reintroduce-test |awk '{print $2}'|sort -n |tail -1`


if [ "$DS2_VERSION" == "$VERSION" ]; then
        sudo docker push $REPOSITORY_ADDR/deepstats-reintroduce-test:$VERSION
else
        echo false
fi




# scallout pods
ssh -p 2201 core@42.159.27.69 -C 'bash  /home/core/deployment/deepstats-reintroduce.sh'
