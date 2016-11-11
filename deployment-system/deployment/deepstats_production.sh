#!/bin/bash

LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/deepstats/tags/list' | /home/core/deployment/jq '."tags"[]' |sort |tail -1 | tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
	/opt/bin/kubectl rolling-update deepstats-aggregate-day-genurl --image=r.fds.so:5000/deepstats:"$CURRENT_VERSION" --namespace=ds-production & \
	/opt/bin/kubectl rolling-update deepstats-aggregate-day-others --image=r.fds.so:5000/deepstats:"$CURRENT_VERSION" --namespace=ds-production & \
	/opt/bin/kubectl rolling-update deepstats-aggregate-day-sharelink --image=r.fds.so:5000/deepstats:"$CURRENT_VERSION" --namespace=ds-production & \
	/opt/bin/kubectl rolling-update deepstats-aggregate-hour-genurl  --image=r.fds.so:5000/deepstats:"$CURRENT_VERSION" --namespace=ds-production  & \
	/opt/bin/kubectl rolling-update deepstats-aggregate-hour-others  --image=r.fds.so:5000/deepstats:"$CURRENT_VERSION" --namespace=ds-production  & \
	/opt/bin/kubectl rolling-update deepstats-aggregate-hour-sharelink  --image=r.fds.so:5000/deepstats:"$CURRENT_VERSION" --namespace=ds-production  & \
	/opt/bin/kubectl rolling-update deepstats-aggregate-total  --image=r.fds.so:5000/deepstats:"$CURRENT_VERSION"  --namespace=ds-production & \
	/opt/bin/kubectl rolling-update deepstats-api --image=r.fds.so:5000/deepstats:"$CURRENT_VERSION"  --namespace=ds-production & \
	/opt/bin/kubectl rolling-update deepstats-appchannel  --image=r.fds.so:5000/deepstats:"$CURRENT_VERSION"  --namespace=ds-production & \
	/opt/bin/kubectl rolling-update deepstats-appevent--image=r.fds.so:5000/deepstats:"$CURRENT_VERSION"  --namespace=ds-production  & \
	/opt/bin/kubectl rolling-update deepstats-usage  --image=r.fds.so:5000/deepstats:"$CURRENT_VERSION"  --namespace=ds-production 
else
	/opt/bin/kubectl rolling-update deepstats-aggregate-day-genurl --image=r.fds.so:5000/deepstats:"$LAST_VERSION" --namespace=ds-production & \
	/opt/bin/kubectl rolling-update deepstats-aggregate-day-others --image=r.fds.so:5000/deepstats:"$LAST_VERSION" --namespace=ds-production & \
	/opt/bin/kubectl rolling-update deepstats-aggregate-day-sharelink --image=r.fds.so:5000/deepstats:"$LAST_VERSION" --namespace=ds-production & \
        /opt/bin/kubectl rolling-update deepstats-aggregate-hour-genurl  --image=r.fds.so:5000/deepstats:"$LAST_VERSION" --namespace=ds-production & \
        /opt/bin/kubectl rolling-update deepstats-aggregate-hour-others  --image=r.fds.so:5000/deepstats:"$LAST_VERSION" --namespace=ds-production & \
        /opt/bin/kubectl rolling-update deepstats-aggregate-hour-sharelink  --image=r.fds.so:5000/deepstats:"$LAST_VERSION" --namespace=ds-production & \
        /opt/bin/kubectl rolling-update deepstats-aggregate-total  --image=r.fds.so:5000/deepstats:"$LAST_VERSION"  --namespace=ds-production &  \
        /opt/bin/kubectl rolling-update deepstats-api  --image=r.fds.so:5000/deepstats:"$LAST_VERSION"  --namespace=ds-production & \
        /opt/bin/kubectl rolling-update deepstats-appchannel --image=r.fds.so:5000/deepstats:"$LAST_VERSION"  --namespace=ds-production & \
        /opt/bin/kubectl rolling-update deepstats-appevent  --image=r.fds.so:5000/deepstats:"$LAST_VERSION"  --namespace=ds-production & \
        /opt/bin/kubectl rolling-update deepstats-usage  --image=r.fds.so:5000/deepstats:"$LAST_VERSION"  --namespace=ds-production 
fi
