#!/bin/bash

suss_result=`/go/src/github.com/MISingularity/deepshare2/deepshare2_apitest.test
 -env production -logfile /opt/deepshare2-api-error.log  |grep PASS`
error_info=`cat /opt/deepshare2-api-error.log`

if [ "$suss_result" != "PASS" ]; then
        echo -e "Subject: production api error\r\n\r\n $error_info " |msmtp  -t
deepshare-alert@misingularity.com
fi
