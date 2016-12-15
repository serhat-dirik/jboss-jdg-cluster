#!/bin/bash
echo "Killing and removing docker containers .... "
for container in jdg-node1 jdg-node2 jdg-node3 ; do
  echo clearing $container
  cstate=$(docker inspect -f {{.State.Running}} $container)
  if  [ -z "$cstate" ] || [ ! $cstate ]  ;  then   continue; fi
  c_ip=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' $container )
  c_ip_esc="$(echo "$c_ip" | sed 's/[^-A-Za-z0-9_]/\\&/g')"
  docker stop $container
  docker kill $container >> /dev/null 2>&1
  docker rm   $container
done
echo "Killed all demo containers! Checking docker processes! "
echo docker ps
docker ps
