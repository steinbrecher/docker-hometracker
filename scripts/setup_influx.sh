#!/bin/bash

set -euo pipefail

echo "Starting InfluxDB..."
service influxdb start

sleep 5

echo "Creating InfluxDB user ${INFLUXDB_ADMIN_USER}"
influx -execute "CREATE USER ${INFLUXDB_ADMIN_USER} WITH PASSWORD '${INFLUXDB_ADMIN_PASSWORD}' WITH ALL PRIVILEGES"
export INFLUX_USERNAME="${INFLUXDB_ADMIN_USER}"
export INFLUX_PASSWORD="${INFLUXDB_ADMIN_PASSWORD}"
echo "Creating InfluxDB user ${INFLUXDB_USER}"
influx -execute "CREATE USER ${INFLUXDB_USER} WITH PASSWORD '${INFLUXDB_PASSWORD}' WITH ALL PRIVILEGES"
influx -execute "CREATE DATABASE ${INFLUXDB_DATABASE_NAME}"

echo "Shutting down InfluxDB"
service influxdb stop
