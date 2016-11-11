#!/bin/bash

# clearup broken rc before deployment starting

BROCKEN_RC=`kubectl get rc --namespace=ds-staging |grep deepshare2-apitest- |awk '{print $1}'`

if [ "$BROCKEN_RC" != " " ]; then
         /opt/bin/kubectl delete rc/$BROCKEN_RC  --namespace=ds-staging
else
    exit 0
fi



# deploy the right version fo app and make a decision to keep the app running when encontering unexpected situation


LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/deepshare2-apitest/tags/list' | /home/core/deployment/jq '."tags"[]' |sort |tail -1  | tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
	/opt/bin/kubectl rolling-update deepshare2-apitest --image r.fds.so:5000/deepshare2-apitest:"$CURRENT_VERSION" --namespace=ds-staging 
else
	/opt/bin/kubectl rolling-update deepshare2-apitest --image r.fds.so:5000/deepshare2-apitest:"$LAST_VERSION"  --namespace=ds-staging
fi
