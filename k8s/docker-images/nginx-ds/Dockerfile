FROM r.fds.so:5000/ds-nginx:201605301

RUN mkdir -p /nginx-conf
RUN mkdir -p /deepshare-cert
ADD ./nginx.conf /nginx-conf/nginx.conf
ADD ./deepshare.io.key /deepshare-cert/deepshare.io.key
ADD ./deepshare.io.crt /deepshare-cert/deepshare.io.crt

EXPOSE 80 443 5000
CMD ["nginx", "-c", "/nginx-conf/nginx.conf", "-g", "daemon off;"]
