#!/bin/bash

set -euo pipefail

# Set up environment variables for influx
echo "export INFLUXDB_HTTP_HTTPS_CERTIFICATE=${HTTPS_CERT}" >> /etc/default/influxdb
echo "export INFLUXDB_HTTP_HTTPS_PRIVATE_KEY=${HTTPS_CERT_KEY}" >> /etc/default/influxdb
echo "export INFLUXDB_HTTP_BIND_ADDRESS=:${INFLUXDB_PORT}" >> /etc/default/influxdb

echo "Starting InfluxDB..."
service influxdb start

sleep 5

echo "Creating InfluxDB user ${INFLUXDB_ADMIN_USER}"
influx -ssl -unsafeSsl -host '127.0.0.1' -port "${INFLUXDB_PORT}" -execute "CREATE USER ${INFLUXDB_ADMIN_USER} WITH PASSWORD '${INFLUXDB_ADMIN_PASSWORD}' WITH ALL PRIVILEGES"
export INFLUX_USERNAME="${INFLUXDB_ADMIN_USER}"
export INFLUX_PASSWORD="${INFLUXDB_ADMIN_PASSWORD}"
echo "Creating InfluxDB user ${INFLUXDB_USER}"
influx -ssl -unsafeSsl -host '127.0.0.1' -port "${INFLUXDB_PORT}" -execute "CREATE USER ${INFLUXDB_USER} WITH PASSWORD '${INFLUXDB_PASSWORD}' WITH ALL PRIVILEGES"
influx -ssl -unsafeSsl -host '127.0.0.1' -port "${INFLUXDB_PORT}" -execute "CREATE DATABASE ${INFLUXDB_DATABASE_NAME}"

echo "Shutting down InfluxDB"
service influxdb stop
