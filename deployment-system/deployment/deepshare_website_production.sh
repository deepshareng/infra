#!/bin/bash

# clearup broken rc before deployment starting

BROCKEN_RC=`/opt/bin/kubectl get rc --namespace=ds-production |grep deepshare-website- |awk '{print $1}'`

if [ "$BROCKEN_RC" != " " ]; then
         /opt/bin/kubectl delete rc/$BROCKEN_RC  --namespace=ds-production
else
    exit 0
fi



# deploy the right version fo app and make a decision to keep the app running when encontering unexpected situation

CURRENT_VERSION=`/opt/bin/kubectl get pods -o yaml --namespace=ds-production |grep -B 3 website   |grep image |grep jekyll |head -1 |awk -F':' '{print $4}'`


if [ "$CURRENT_VERSION" == 1 ]; then
	/opt/bin/kubectl rolling-update deepshare-website  --image=r.fds.so:5000/jekyll:2  --namespace=ds-production
else
	/opt/bin/kubectl rolling-update deepshare-website  --image=r.fds.so:5000/jekyll:1  --namespace=ds-production
fi




