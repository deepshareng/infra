#!/bin/bash

LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/deepdash-redis-staging/tags/list' | /home/core/deployment/jq '."tags"[]' |sort |tail -1  | tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
	/opt/bin/kubectl rolling-update deepdash-redis-info --image r.fds.so:5000/deepdash-redis-staging:"$CURRENT_VERSION" --namespace=ds-staging
else
	/opt/bin/kubectl rolling-update deepdash-redis-info  --image r.fds.so:5000/deepdash-redis-staging:"$LAST_VERSION" --namespace=ds-staging
fi
