#!/bin/bash

LAST_VERSION=`curl -s -S 'https://r.fds.so:5000/v2/deepshare2/tags/list' | /home/core/deployment/jq '."tags"[]' |sort -n |tail -2 |grep -v redis| tr  -d '"'`
CURRENT_VERSION=$(date +%Y%m%d%H%M)

if [ $CURRENT_VERSION == $LAST_VERSION ]; then
	/opt/bin/kubectl rolling-update deepshare2-appinfo --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION" --namespace=ds-production  & \
	  /opt/bin/kubectl rolling-update deepshare2-genurl  --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION" --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-bind  --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION"  --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-cookie  --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION"  --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-counter --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION"  --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-dsaction  --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION"  --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-dsusage  --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION"  --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-inappdata  --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION"  --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-sharelink  --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION"  --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-match --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION" --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-appcookie --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION" --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-jsapi --image=r.fds.so:5000/deepshare2:"$CURRENT_VERSION" --namespace=ds-production
	  
else
	/opt/bin/kubectl rolling-update deepshare2-appinfo --image=r.fds.so:5000/deepshare2:"$LAST_VERSION" --namespace=ds-production & \
          /opt/bin/kubectl rolling-update deepshare2-genurl  --image=r.fds.so:5000/deepshare2:"$LAST_VERSION" --namespace=ds-production &  \
          /opt/bin/kubectl rolling-update deepshare2-bind  --image=r.fds.so:5000/deepshare2:"$LAST_VERSION"  --namespace=ds-production & \
          /opt/bin/kubectl rolling-update deepshare2-cookie  --image=r.fds.so:5000/deepshare2:"$LAST_VERSION"  --namespace=ds-production & \
          /opt/bin/kubectl rolling-update deepshare2-counter --image=r.fds.so:5000/deepshare2:"$LAST_VERSION"  --namespace=ds-production  & \
          /opt/bin/kubectl rolling-update deepshare2-dsaction  --image=r.fds.so:5000/deepshare2:"$LAST_VERSION"  --namespace=ds-production & \
          /opt/bin/kubectl rolling-update deepshare2-dsusage  --image=r.fds.so:5000/deepshare2:"$LAST_VERSION"  --namespace=ds-production & \
          /opt/bin/kubectl rolling-update deepshare2-inappdata  --image=r.fds.so:5000/deepshare2:"$LAST_VERSION"  --namespace=ds-production & \
          /opt/bin/kubectl rolling-update deepshare2-sharelink  --image=r.fds.so:5000/deepshare2:"$LAST_VERSION"  --namespace=ds-production & \
          /opt/bin/kubectl rolling-update deepshare2-match --image=r.fds.so:5000/deepshare2:"$LAST_VERSION" --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-appcookie --image=r.fds.so:5000/deepshare2:"$LAST_VERSION" --namespace=ds-production & \
	  /opt/bin/kubectl rolling-update deepshare2-jsapi --image=r.fds.so:5000/deepshare2:"$LAST_VERSION" --namespace=ds-production
fi
