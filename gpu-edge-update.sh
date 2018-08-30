#!/bin/bash

set -e

if [ "-h" = "$1" ]; then
  echo "Removes all old Gigantum LabManager GPU-Edge instances and updates to latest"
  echo "Once run, you can then execute 'gigantum start -e' to start GPU enabled mode"
  exit 0
fi


echo "Removing all old gpu-edge images ..."
imgs=$(docker images | grep gpu-edge | awk '{ print $3 }')
if [ ! -z $imgs ]; then
  echo $imgs | xargs docker rmi -f
fi

echo "Pulling gigantum/gpu-edge ..."
docker pull gigantum/gpu-edge

echo "Retagging gigantum/gpu-edge to gigantum/labmanager-edge ..."
gpu_edge_id=$(docker images | grep gpu-edge | awk '{ print $3 }')
if [ -z $gpu_edge_id ]; then
  echo "Error - could not find docker image tag for gigantum/gpu-edge"
  exit 1
fi
docker tag $gpu_edge_id gigantum/labmanager-edge


img_id=$(docker images | grep labmanager-edge | awk '{ print $3 }')
if [ "$img_id" = "$gpu_edge_id" ]; then
	echo "Complete, gigantum/gpu-edge and gigantum/labmanager-edge: $gpu_edge_id"
	echo "You may now run 'gigantum start -e'"
	exit 0
fi

echo "Failed to apply tag"
exit 1
