#!/bin/bash

LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/deepdash-test/tags/list' | /home/core/deployment/jq '."tags"[]' |sort |tail -1 | tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
        /opt/bin/kubectl rolling-update deepdash  --image=r.fds.so:5000/deepdash-test:"$CURRENT_VERSION" --namespace=production 
else
        /opt/bin/kubectl rolling-update deepdash  --image=r.fds.so:5000/deepdash-test:"$LAST_VERSION" --namespace=production 
fi
