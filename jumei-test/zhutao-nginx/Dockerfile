FROM r.fds.so:5000/fds-nginx:2016070301

RUN mkdir -p /nginx-conf
RUN mkdir -p /zhutao-cert
RUN mkdir -p /var/cache/nginx/client_temp
ADD ./nginx.conf /nginx-conf/nginx.conf
ADD ./data2server/zhutao.crt /zhutao-cert/zhutao.crt
ADD ./data2server/zhutao.csr /zhutao-cert/zhutao.csr
ADD ./data2server/zhutao.key /zhutao-cert/zhutao.key

EXPOSE 443 5000
CMD ["/usr/sbin/nginx", "-c", "/nginx-conf/nginx.conf", "-g", "daemon off;"]
