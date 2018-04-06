#!/bin/bash
if ! docker inspect lms >/dev/null 2>&1 ; then
  echo "Start LMS ..."
  docker run -d --name lms --dns 192.168.1.1 --restart always --net host -p 9000:9000 -p 9090:9090 -p 3483:3483 -p 5353:5353 -p 3483:3483/udp -v /media/Data/squeezebox:/srv/squeezebox  -v /media:/media -v /etc/localtime:/etc/localtime:ro dil001/logitechmediaserver-arm32v7:7.9.1
fi

if [ -f "$(pwd)/nginx.conf" ]; then
  if ! docker inspect lms-proxy >/dev/null 2>&1 ; then 
    echo "Start LMS proxy..."
    docker run --name lms-proxy --restart always -p 80:80 -v $(pwd)/nginx.conf:/etc/nginx/conf.d/lms.conf:ro -d arm64v8/nginx
  fi
fi
