JBoss Data Grid Cluster
========================
  A simple composition of docker image containers to create a 3 node JBoss Data Grid  v7 cluster.

How to run?
-----------------
  Simply execute runDemo.sh script. This script creates a JDG cluster that has 3 nodes as named as jdg-node1, jdg-node2, jdg-node3.  In addition to those nodes an additional dns container that named as docker-dns is also created and configured as dns in grid nodes, so each grid node can reach to other nodes by their names.

Prerequisites
-----------------
  jboss-demo/jdg:7 docker image must be in your local docker repo 
