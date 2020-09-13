#!/bin/bash

docker run --env-file env --ulimit nofile=66000:66000 -d --name docker-statsd-influxdb-grafana -p 443:3003 -p 8086:8086 grafana:1.0