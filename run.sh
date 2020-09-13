#!/bin/bash

docker run --env-file env --ulimit nofile=66000:66000 -d --name docker-statsd-influxdb-grafana -p 3003:3003 -p 3004:8888 -p 8086:8086 -p 8125:8125/udp grafana:1.0