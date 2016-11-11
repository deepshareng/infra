FROM r.fds.so:5000/backup3

RUN mkdir -p /opt
RUN rm -rf /opt/*
RUN mkdir -p /data
RUN rm -rf /data/*

ADD ./crontab                            /etc/crontab
ADD ./new-node.pem                       /opt/new-node.pem
ADD ./redis_data_7000_day.sh             /opt/redis_data_7000_day.sh
ADD ./redis_dsusage_data_day.sh          /opt/redis_dsusage_data_day.sh
ADD ./dashboard_deepdash_day.sh          /opt/dashboard_deepdash_day.sh
ADD ./dashboard_oauth_day.sh             /opt/dashboard_oauth_day.sh
ADD ./deepstats_nsql_day.sh              /opt/deepstats_nsql_day.sh
ADD ./start-cron.sh                      /opt/start-cron.sh

CMD ["bash","/opt/start-cron.sh"]
