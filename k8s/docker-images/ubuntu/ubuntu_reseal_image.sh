#!/bin/bash

DATE=$(date +%Y%m%d)

docker pull ubuntu:latest

docker tag ubuntu:latest r.fds.so:5000/ubuntu:${DATE}

docker push r.fds.so:5000/ubuntu:${DATE}

echo "Ubuntu docker images reseal Success!"
echo "Image: r.fds.so:5000/ubuntu:${DATE}"
echo
