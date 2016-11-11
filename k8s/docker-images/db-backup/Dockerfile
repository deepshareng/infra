FROM r.fds.so:5000/backup3:2016072801

#RUN sed -i s/'archive.ubuntu.com'/'mirrors.ustc.edu.cn'/g /etc/apt/sources.list
#RUN apt-get update
#RUN apt-get -y install openssh-client vim curl iproute2 cron rsyslog
#RUN apt-get -y install build-essential libssl-dev libffi-dev libpython-dev python-dev python-pip
#RUN pip install --upgrade blobxfer
#RUN apt-get clean

RUN mkdir -p /opt

ADD ./crontab          /etc/crontab
ADD ./new-node.pem     /opt/new-node.pem
ADD ./redis_backup.sh  /opt/redis_backup.sh
ADD ./mongo_backup.sh  /opt/mongo_backup.sh
ADD ./start-cron.sh    /opt/start-cron.sh

CMD ["bash","/opt/start-cron.sh"]
