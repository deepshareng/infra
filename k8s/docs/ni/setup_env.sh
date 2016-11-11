# depends
mongoHost=linan.chinacloudapp.cn
mongoPort=26001
esAddress=https://ni-ela:dDhzs4AwSKcxHft6@ni.singulariti.io:9200

# expose on your machine(the port could modify in case of conflict with existed service)
niLoggingGrpcPort=15000
niPort=9001
niTrackingPort=15002
trackingServerQueryServerPort=15003
trackingServerBeServerPort=15004
niServerPort=9002

localhost=127.0.0.1
dockerhost=172.17.0.1

#service Addresses(change if you deploy service by code)
niAddress=$dockerhost:$niPort
trackingAddress=http://$dockerhost:$trackingServerQueryServerPort
niTrackingAddress=$dockerhost:$niTrackingPort

# docker images
grpcLoggingImage=r.fds.so:5000/grpc_logging
niImage=r.fds.so:5000/ni
niTrackingImage=r.fds.so:5000/ni_tracking:v0.2
trackingServerImage=r.fds.so:5000/tracking_server:v0.1
niServerImage=r.fds.so:5000/ni_server

# rm existed docker container
sudo docker rm -f grpc_logging ni ni_tracking tracking_api tracking_grpc ni_server

# set dir for docker
ddir=~/docker_folder
if [ ! -d "$ddir" ]; then
mkdir "$ddir"
fi

# you can replace any service with your own 

# start grpc_logging 
sudo docker pull $grpcLoggingImage
sudo docker run --name grpc_logging -p $niLoggingGrpcPort:50051 -v $ddir/grpc_logging:/go/src/github.com/MISingularity/logging/log -d $grpcLoggingImage /go/src/github.com/MISingularity/logging/logging_server --mongo-host $mongoHost --mongo-port $mongoPort

# start ni
sudo docker pull $niImage
sudo docker run --name ni -p $niPort:11000 -d $niImage /home/cpp/ni/bazel-bin/server/server --ip 0.0.0.0

# start NITracking
sudo docker pull $niTrackingImage
sudo docker run --name ni_tracking -v $ddir/tracking_log:/go/src/github.com/MISingularity/TrackingServer/log -p $niTrackingPort:50052 -d $niTrackingImage

# start TrackingServer
sudo docker pull $trackingServerImage
sudo docker run --name tracking_api -p $trackingServerQueryServerPort:11002 -d $trackingServerImage /go/src/github.com/MISingularity/TrackingServer/query_server --mongo-url $mongoHost:$mongoPort --tracking-client-address $niTrackingAddress
sudo docker run --name tracking_grpc -p $trackingServerBeServerPort:50051 -d $trackingServerImage /go/src/github.com/MISingularity/TrackingServer/be_server --mongo-host $mongoHost --mongo-port $mongoPort --tracking-client-address $niTrackingAddress

# start NiServer
sudo docker pull $niServerImage
sudo docker run --name ni_server -p $niServerPort:11003  -v $ddir/ni_server:/go/src/github.com/MISingularity/logging/log -d $niServerImage /go/src/github.com/MISingularity/NiServer/ni_server --ni-grpc-address $niAddress --es-address $esAddress --tracking-address $trackingAddress

