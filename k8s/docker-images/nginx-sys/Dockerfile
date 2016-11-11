FROM nginx:1.9.5

RUN mkdir -p /nginx-conf
RUN mkdir -p /nginx-cert
ADD ./nginx.conf /nginx-conf/nginx.conf
ADD ./fds.so.crt /nginx-cert/fds.so.crt
ADD ./fds.so.key /nginx-cert/fds.so.key
ADD ./deepshare.io.key /nginx-cert/deepshare.io.key
ADD ./deepshare.io.crt /nginx-cert/deepshare.io.crt

EXPOSE 80 443 5000
CMD ["nginx", "-c", "/nginx-conf/nginx.conf", "-g", "daemon off;"]
