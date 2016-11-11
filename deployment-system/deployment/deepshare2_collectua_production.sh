#!/bin/bash

LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/deepshare2-collectua/tags/list' | /home/core/deployment/jq '."tags"[]' |sort |tail -1  | tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
	/opt/bin/kubectl rolling-update collect-ua --image r.fds.so:5000/deepshare2-collectua:"$CURRENT_VERSION" --namespace=ds-production 
else
	/opt/bin/kubectl rolling-update collect-ua  --image r.fds.so:5000/deepshare2-collectua:"$LAST_VERSION"  --namespace=ds-production
fi
