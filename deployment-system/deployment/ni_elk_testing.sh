#!/bin/bash

# clearup broken rc before deployment starting

BROCKEN_RC=`kubectl get rc --namespace=ni-testing  |grep el- |awk '{print $1}'`

if [ "$BROCKEN_RC" != " " ]; then
         /opt/bin/kubectl delete rc/$BROCKEN_RC  --namespace=ni-testing
else
    exit 0
fi



# deploy the right version fo app and make a decision to keep the app running when encontering unexpected situation


LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/ni-onlinesearch-test/tags/list' | /home/core/deployment/jq '."tags"[]' |sort |tail -1 | tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
	/opt/bin/kubectl rolling-update el --image=r.fds.so:5000/ni-onlinesearch-test:"$CURRENT_VERSION"  --namespace=ni-testing 
else
        /opt/bin/kubectl rolling-update el  --image=r.fds.so:5000/ni-onlinesearch-test:"$LAST_VERSION"  --namespace=ni-testing
fi
