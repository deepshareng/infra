# deploy the right version fo app and make a decision to keep the app running when encontering unexpected situation

CURRENT_VERSION=`/opt/bin/kubectl get pods -o yaml --namespace=ds-staging |grep -B 3 website   |grep image |grep jekyll |head -1 |awk -F':' '{print $4}'`


if [ "$CURRENT_VERSION" == 1 ]; then
        /opt/bin/kubectl rolling-update deepshare-website  --image=r.fds.so:5000/jekyll:2  --namespace=ds-staging
else
        /opt/bin/kubectl rolling-update deepshare-website  --image=r.fds.so:5000/jekyll:1  --namespace=ds-staging
fi

