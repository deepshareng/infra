FROM r.fds.so:5000/ni-nginx:20160520

RUN mkdir -p /nginx-conf
RUN mkdir -p /nginx-cert
ADD ./nginx.conf /nginx-conf/nginx.conf
ADD ./singulariti.io.key /nginx-cert/singulariti.io.key
ADD ./singulariti.io.crt /nginx-cert/singulariti.io.crt
ADD ./htpasswd /nginx-cert/htpasswd

EXPOSE 80 443 9200 9201
CMD ["nginx", "-c", "/nginx-conf/nginx.conf", "-g", "daemon off;"]
