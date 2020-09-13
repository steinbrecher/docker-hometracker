#!/bin/sh
docker build --tag grafana:1.0 $(sed '/^$/d' env | sed 's/^/--build-arg /' | paste -sd' ' -) "$@" .