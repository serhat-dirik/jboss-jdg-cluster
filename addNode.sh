#!/bin/bash

if  [ -z "$1" ];  then
  echo "sh addNode.sh nodeName"
  exit
fi
#docker run -d -v /var/run/docker.sock:/docker.sock --privileged --name docker-dns --hostname docker-dns crosbymichael/skydock -ttl 30 -environment dev -s /docker.sock -domain docker -name docker-dns
CSTATE=$(docker inspect -f {{.State.Running}} docker-dns)
echo "Is docker-dns started ? $CSTATE"
if  ! $CSTATE  ;  then   exit 1; fi

_DNS_IP=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' docker-dns)
echo "Starting JDG Node $1" ...
docker run -d --name $1 --hostname $1 -v $(pwd)/jdgConfig:/jdgConfig --dns $_DNS_IP --dns-search docker jboss-demo/jdg:7 /bin/bash -c "/jdgConfig/executeDemo.sh"

echo Done!
