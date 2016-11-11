#!/bin/bash

LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/deepstats-test/tags/list' | /home/core/deployment/jq '."tags"[]' |sort |tail -1 | tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
        /opt/bin/kubectl rolling-update deepstats-aggregate-day  --image=r.fds.so:5000/deepstats-test:"$CURRENT_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-aggregate-hour  --image=r.fds.so:5000/deepstats-test:"$CURRENT_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-aggregate-total  --image=r.fds.so:5000/deepstats-test:"$CURRENT_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-api             --image=r.fds.so:5000/deepstats-test:"$CURRENT_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-appchannel  --image=r.fds.so:5000/deepstats-test:"$CURRENT_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-appevent  --image=r.fds.so:5000/deepstats-test:"$CURRENT_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-backup  --image=r.fds.so:5000/deepstats-test:"$CURRENT_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-usage  --image=r.fds.so:5000/deepstats-test:"$CURRENT_VERSION" --namespace=production 
else
        /opt/bin/kubectl rolling-update deepstats-aggregate-day --image=r.fds.so:5000/deepstats-test:"$LAST_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-aggregate-hour --image=r.fds.so:5000/deepstats-test:"$LAST_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-aggregate-total --image=r.fds.so:5000/deepstats-test:"$LAST_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-api              --image=r.fds.so:5000/deepstats-test:"$LAST_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-appchannel     --image=r.fds.so:5000/deepstats-test:"$LAST_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-appevent       --image=r.fds.so:5000/deepstats-test:"$LAST_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-backup       --image=r.fds.so:5000/deepstats-test:"$LAST_VERSION" --namespace=production 
        /opt/bin/kubectl rolling-update deepstats-usage       --image=r.fds.so:5000/deepstats-test:"$LAST_VERSION" --namespace=production 
fi
