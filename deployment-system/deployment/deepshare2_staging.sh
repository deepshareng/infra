#!/bin/bash




# deploy the right version fo app and make a decision to keep the app running when encontering unexpected situation


LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/deepshare2-staging/tags/list' | /home/core/deployment/jq '."tags"[]' |sort |tail -1 | tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
	/opt/bin/kubectl rolling-update deepshare2-appinfo --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION" --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-genurl  --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION" --namespace=ds-staging  & \
	/opt/bin/kubectl rolling-update deepshare2-bind  --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION"  --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-cookie  --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION"  --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-counter  --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION"  --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-dsaction  --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION"  --namespace=ds-staging  & \
	/opt/bin/kubectl rolling-update deepshare2-dsusage  --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION"  --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-inappdata  --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION"  --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-sharelink  --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION"  --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-match --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION" --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-appcookie --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION" --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-jsapi --image=r.fds.so:5000/deepshare2-staging:"$CURRENT_VERSION" --namespace=ds-staging
else
	/opt/bin/kubectl rolling-update deepshare2-appinfo --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION" --namespace=ds-staging & \
        /opt/bin/kubectl rolling-update deepshare2-genurl  --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION" --namespace=ds-staging & \
        /opt/bin/kubectl rolling-update deepshare2-bind  --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION"  --namespace=ds-staging &  \
        /opt/bin/kubectl rolling-update deepshare2-cookie  --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION"  --namespace=ds-staging & \
        /opt/bin/kubectl rolling-update deepshare2-counter  --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION"  --namespace=ds-staging & \
        /opt/bin/kubectl rolling-update deepshare2-dsaction  --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION"  --namespace=ds-staging & \
        /opt/bin/kubectl rolling-update deepshare2-dsusage  --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION"  --namespace=ds-staging & \
        /opt/bin/kubectl rolling-update deepshare2-inappdata  --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION"  --namespace=ds-staging & \
        /opt/bin/kubectl rolling-update deepshare2-sharelink  --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION"  --namespace=ds-staging & \
        /opt/bin/kubectl rolling-update deepshare2-match --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION" --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-appcookie --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION" --namespace=ds-staging & \
	/opt/bin/kubectl rolling-update deepshare2-jsapi --image=r.fds.so:5000/deepshare2-staging:"$LAST_VERSION" --namespace=ds-staging
fi
