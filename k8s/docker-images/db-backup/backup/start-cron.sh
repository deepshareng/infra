#!/bin/sh

rsyslogd
touch /var/log/cron.log
cron
tail -F /var/log/syslog /var/log/cron.log
