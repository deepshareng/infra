#!/bin/bash



VERSION=$(date +%Y%m%d%H%M)

CODE_DIR=/mnt/prod/deepstats
REPOSITORY_ADDR=r.fds.so:5000

cd $CODE_DIR;  sudo docker build -f Dockerfile_deepstats  -t  $REPOSITORY_ADDR/deepstats:$VERSION .


DS2_VERSION=`sudo docker images |grep deepstats |awk '{print $2}'|sort -n |tail -1`


if [ "$DS2_VERSION" == "$VERSION" ]; then
        sudo docker push $REPOSITORY_ADDR/deepstats:$VERSION
else
        echo false
fi




# scallout pods
ssh -p 2201 core@fds.so -C 'bash  /home/core/deployment/deepstats_production.sh'
