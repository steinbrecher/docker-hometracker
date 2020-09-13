#!/bin/bash

docker container stop $(docker container list | grep docker-hometracker | awk '{print $1}') 
docker container prune