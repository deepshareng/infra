#!/bin/sh
# start-cron.sh

rsyslogd
touch /var/log/cron.log
touch /etc/crontab /etc/cron.*/*
cron
tail -F /var/log/syslog /var/log/cron.log
