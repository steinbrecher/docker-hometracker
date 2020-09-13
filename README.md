# Docker Image with InfluxDB and Grafana for HTTPS

Based on [this image](https://github.com/samuelebistoletti/docker-statsd-influxdb-grafana).

NOTE: Work in progress

## Versions

* Docker Image:      2.3.0
* Ubuntu:            18.04
* InfluxDB:          1.8.2
* Grafana:           7.1.5

## Quick Start

- Clone this repository
- Move `env-template` to `env`
- Fill in your own details
- Build and run

## Mapped Ports

```
Host		Container		Service

443		3003			grafana
8086		8086			influxdb
```

## Grafana

Open <https://localhost>

