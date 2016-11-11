#!/bin/sh
touch /var/log/cron.log
rsyslogd
cron
crontab /etc/crontab
touch /etc/crontab /etc/cron.*/*
tail -F /var/log/syslog /var/log/cron.log
