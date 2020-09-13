#!/bin/sh
docker build --network=host --tag hometracker:1.0 $(sed '/^$/d' env | sed 's/^/--build-arg /' | paste -sd' ' -) "$@" .