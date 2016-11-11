#!/bin/bash

LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/deepstats-backup/tags/list' | /home/core/deployment/jq '."tags"[]' |sort |tail -1 | tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
	/opt/bin/kubectl rolling-update deepstats-backup  --image=r.fds.so:5000/deepstats-backup:"$CURRENT_VERSION" --namespace=ds-production 
else
	/opt/bin/kubectl rolling-update deepstats-backup  --image=r.fds.so:5000/deepstats-backup:"$LAST_VERSION" --namespace=ds-production 
fi
