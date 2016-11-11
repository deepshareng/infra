FROM r.fds.so:5000/jumei-nginx:2016071301


RUN sed -i s/'archive.ubuntu.com'/'mirrors.ustc.edu.cn'/g /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install  curl iproute2
RUN apt-get clean

RUN mkdir -p /nginx-conf
RUN mkdir -p /jumei-cert
RUN mkdir -p /var/cache/nginx/client_temp
ADD ./nginx /usr/sbin/nginx
ADD ./nginx.conf /nginx-conf/nginx.conf
ADD ./data2server/jumei/jumei.crt /jumei-cert/jumei.crt
ADD ./data2server/jumei/jumei.key /jumei-cert/jumei.key

EXPOSE 443 5000
CMD ["/usr/sbin/nginx", "-c", "/nginx-conf/nginx.conf", "-g", "daemon off;"]
