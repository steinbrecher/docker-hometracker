#!/bin/bash

# Set up environment variables for influx
echo "export INFLUXDB_DATABASE_NAME=${INFLUXDB_DATABASE_NAME}" >> /etc/default/grafana-server
echo "export INFLUXDB_USER=${INFLUXDB_USER}" >> /etc/default/grafana-server
echo "export INFLUXDB_PASSWORD=${INFLUXDB_PASSWORD}" >> /etc/default/grafana-server
echo "export SERVER_URL=${SERVER_URL}" >> /etc/default/grafana-server
echo "export GRAFANA_ADMIN_USER=${GRAFANA_ADMIN_USER}" >> /etc/default/grafana-server
echo "export GRAFANA_ADMIN_PW=${GRAFANA_ADMIN_PW}" >> /etc/default/grafana-server