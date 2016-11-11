FROM r.fds.so:5000/registry:2.2.1

RUN mkdir -p /etc/docker/registry
RUN mkdir -p /certs
ADD ./config.yml /etc/docker/registry/config.yml
ADD ./fds.so.crt /certs/fds.so.crt
ADD ./fds.so.key /certs/fds.so.key

EXPOSE 5000
ENTRYPOINT ["/bin/registry"]
CMD ["/etc/docker/registry/config.yml"]