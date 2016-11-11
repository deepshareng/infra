#!/bin/bash

# clearup broken rc before deployment starting

BROCKEN_RC=`/opt/bin/kubectl get rc --namespace=ds-production |grep deepshare2-dsusage- |awk '{print $1}'`

if [ "$BROCKEN_RC" != " " ]; then
         /opt/bin/kubectl delete rc/$BROCKEN_RC  --namespace=ds-production
else
    exit 0
fi


LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/ds-dsusage/tags/list' | /home/core/deployment/jq '."tags"[]' |sort -n |tail -1 | tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
	  /opt/bin/kubectl rolling-update deepshare2-dsusage  --image=r.fds.so:5000/ds-dsusage:"$CURRENT_VERSION" --namespace=ds-production & \
	  
else
          /opt/bin/kubectl rolling-update deepshare2-dsusage  --image=r.fds.so:5000/ds-dsusage:"$LAST_VERSION" --namespace=ds-production &  \
fi
