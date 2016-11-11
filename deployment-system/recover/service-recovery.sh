#!/bin/bash

# this script is using for taken recovery jobs on deployment server
# mingfeng.zhang
# 2016/03/16

docker rm -f $(docker ps -a  |awk '{print $1}' |grep -v CON)
#firsh deploy related docker of services on deployment  server
# 1, mysql deployment
export MYSQL_ROOT_PASSWORD='abc123' # this password will be used for mysql default password
NETWORK_ADDR=`ifconfig eth0 |grep "inet addr" |awk -F: '{print $2}'  |awk '{print $1}'`

docker run -d -e MYSQL_ROOT_PASSWORD -p 3306:3306 r.fds.so:5000/mysql-server:latest

mysql -uroot -p$MYSQL_ROOT_PASSWORD -h $NETWORK_ADDR < *.sql


# deploy app service
sudo sudo sed -i 's/100.74.66.4/'"$NETWORK_ADDR"'/g' $(pwd')/conf/local.php $(pwd')/conf/web.php

docker run -d -p 80:80 $(pwd)/conf:/data/walle-web r.fds.so:5000/deployment-server






