 1. mongodb
    image: r.fds.so:5000/mongo
    depands: None
    expose: 27017
    volumns: /data/db
    cmd: None

> 参考:
> sudo docker run --name mongodb  -p 6000:27017 -v /docker_data/mongo_data:/data/db -d r.fds.so:5000/mongo


2. Elastic Search [external access]
    image: r.fds.so:5000/online_search:v0.1
    depands: None
    expose: 9200
    volumns: /usr/share/elasticsearch/data
    cmd: None
> 参考:
> sudo docker run --name elastic_search -p 6001:9200 -v /docker_data/elastic_data:/usr/share/elasticsearch/data -d  r.fds.so:5000/online_search:v0.1

3. ni-logging
    image: r.fds.so:5000/grpc_logging:v0.1
    depands: mongodb
    expose: 50051
    volumns: /go/src/github.com/MISingularity/logging/log
    cmd: /go/src/github.com/MISingularity/logging/logging_server --mongo-host <MONGODB_HOST> --mongo-port <MONGODB_PORT>
> 参考:
> sudo docker run --name grpc_logging -p 7000:50051 -v /docker_data/log:/go/src/github.com/MISingularity/logging/log -d r.fds.so:5000/grpc_logging:v0.1 /go/src/github.com/MISingularity/logging/logging_server --mongo-host 172.17.0.1 --mongo-port 6000

4. ni [external access]
    image: r.fds.so:5000/ni:v0.1
    depands: None
    expose: 11000
    volumns: None
    cmd: /home/cpp/ni/bazel-bin/server/server --ip 0.0.0.0
> 参考:
> sudo docker run --name ni -p 6006:11000 -d r.fds.so:5000/ni:v0.1 /home/cpp/ni/bazel-bin/server/server --ip 0.0.0.0

5. ni-tracking
    image: r.fds.so:5000/ni_tracking:v0.2
    depands: None
    expose: 50052
    volumns: None
    cmd: None
> 参考:
> sudo docker run --name nitracking -p 50052:50052 -d r.fds.so:5000/nitracking:v0.1

6. trackingserver-api
    image: r.fds.so:5000/tracking_server:v0.1
    depands: mongodb, ni-tracking
    expose: 11002
    volumns: None
    cmd: /go/src/github.com/MISingularity/TrackingServer/query_server --mongo-url <MONGODB-ADDR> --tracking-client-address <ni-tracking-ADDR>
> 参考:
>sudo docker run --name tracking_api -p 6004:11002 -d r.fds.so:5000/tracking_server:v0.1 /go/src/github.com/MISingularity/TrackingServer/query_server --mongo-url 172.17.0.1:6000 --tracking-client-address 172.17.0.1:50052

7. trackingserver-grpc [external access]
    image: r.fds.so:5000/tracking_server:v0.1(与6一样)
    depands: mongodb, ni-tracking
    expose: 50051
    volumns: /go/src/github.com/MISingularity/TrackingServer/log
    cmd: /go/src/github.com/MISingularity/TrackingServer/be_server --mongo-host <MONGODB-HOST> --mongo-port <MONGODB-PORT>  --tracking-client-address <ni-tracking-ADDR>
> 参考:
> sudo docker run --name tracking_grpc -p 6003:50051 -v /docker_data/tracking_log:/go/src/github.com/MISingularity/TrackingServer/log -d r.fds.so:5000/tracking_server:v0.1 /go/src/github.com/MISingularity/TrackingServer/be_server --mongo-host 172.17.0.1 --mongo-port 6000  --tracking-client-address 172.17.0.1:50052

8. ni-server [external access]
    image:  r.fds.so:5000/niserver:v0.2
    depands: ni, es, trackingserver-api
    expose: 11003
    volumns: /go/src/github.com/MISingularity/logging/log
    cmd: /go/src/github.com/MISingularity/NiServer/ni_server --ni-grpc-address=<ni-ADDR> --es-address=<ES-ADDR> --tracking-address=<trackingserver-api-ADDR>
> 参考:
> sudo docker run --name ni_server -p 6005:11003  -v /docker_data/ni_server:/go/src/github.com/MISingularity/logging/log -d r.fds.so:5000/niserver:v0.2 /go/src/github.com/MISingularity/NiServer/ni_server --ni-grpc-address=172.17.0.1:6006 --es-address=http://172.17.0.1:6001 --tracking-address=http://172.17.0.1:6004

9. ni-admin [external access]
    image: r.fds.so:5000/ni_admin:v0.1
    depands: mongodb
    expose: 9000
    volumns: None
    cmd: -e MONGODB_HOST=<mongo-host> -e MONGODB_PORT=<mongo-port> -e GRPC_ADDR=linan.chinacloudapp.cn:9001
> 参考:
> sudo docker run --name ni_admin -p 6007:9000 -e MONGODB_HOST=172.17.0.1 -e MONGODB_PORT=6000 -e GRPC_ADDR=linan.chinacloudapp.cn:9001 -d  r.fds.so:5000/ni_admin:v0.1

## external services info
```
Name                       Host                        port
elasticsearch              ni.singulariti.io           9200
ni-grpc                    ni.singulariti.io           32001
ni-trackingserver-grpc     ni.singulariti.io           32002
ni-server                  ni.singulariti.io           32004
```
