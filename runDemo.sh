#!/bin/bash
CSTATE=$(docker inspect -f {{.State.Running}} docker-dns)

if  [ -z "$CSTATE" ];  then
  docker run --privileged --name docker-dns --hostname docker-dns -d -v /var/run/docker.sock:/docker.sock  phensley/docker-dns  --domain docker;
elif ! $CSTATE ; then
  docker start docker-dns
fi
#docker run -d -v /var/run/docker.sock:/docker.sock --privileged --name docker-dns --hostname docker-dns crosbymichael/skydock -ttl 30 -environment dev -s /docker.sock -domain docker -name docker-dns
CSTATE=$(docker inspect -f {{.State.Running}} docker-dns)
echo "Is docker-dns started ? $CSTATE"
if  ! $CSTATE  ;  then   exit 1; fi

_DNS_IP=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' docker-dns)

echo Starting JDG Node1...
docker run -d --name jdg-node1 --hostname jdg-node1.docker -v $(pwd)/jdgConfig:/jdgConfig --dns $_DNS_IP --dns-search docker jboss-demo/jdg:7 /bin/bash -c "/jdgConfig/executeDemo.sh"
echo Starting JDG Node2...
docker run -d --name jdg-node2 --hostname jdg-node2.docker -v $(pwd)/jdgConfig:/jdgConfig --dns $_DNS_IP --dns-search docker jboss-demo/jdg:7 /bin/bash -c "/jdgConfig/executeDemo.sh"
echo Starting JDG Node3...
docker run -d --name jdg-node3 --hostname jdg-node3.docker -v $(pwd)/jdgConfig:/jdgConfig --dns $_DNS_IP --dns-search docker jboss-demo/jdg:7 /bin/bash -c "/jdgConfig/executeDemo.sh"

for container in jdg-node1 jdg-node2 jdg-node3 ; do
  cstate=$(docker inspect -f {{.State.Running}} $container)
  if  [ -z "$cstate" ] || [ ! $cstate ]  ;  then   continue; fi
  c_ip=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' $container )
  echo $container "ip:" $c_ip
done
echo Done!
