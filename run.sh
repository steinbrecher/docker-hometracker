#!/bin/bash

docker run --env-file env --ulimit nofile=66000:66000 -d --name docker-hometracker -p 443:2096 -p 8443:8443 hometracker:1.0