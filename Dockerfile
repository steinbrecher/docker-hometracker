FROM ubuntu:18.04
MAINTAINER Greg Steinbrecher <steinbrecher@alum.mit.edu>

ENV ARCH amd64
#ENV ARCH armhf

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

# Default versions
# ENV TELEGRAF_VERSION 1.13.3-1
ENV INFLUXDB_VERSION 1.8.2
ENV GRAFANA_VERSION  7.1.5
ENV CHRONOGRAF_VERSION 1.8.0

# Default name of influxdb database
ENV INFLUXDB_DATABASE_NAME home_data

ARG INFLUXDB_ADMIN_USER
ARG INFLUXDB_ADMIN_PASSWORD
ENV INFLUXDB_ADMIN_USER=${INFLUXDB_ADMIN_USER}
ENV INFLUXDB_ADMIN_PASSWORD=${INFLUXDB_ADMIN_PASSWORD}

ARG INFLUXDB_USER
ARG INFLUXDB_PASSWORD
ENV INFLUXDB_USER=${INFLUXDB_USER}
ENV INFLUXDB_PASSWORD=${INFLUXDB_PASSWORD}

ARG MYSQL_GRAFANA_USER
ENV MYSQL_GRAFANA_USER=${MYSQL_GRAFANA_USER}

ARG MYSQL_GRAFANA_PW
ENV MYSQL_GRAFANA_PW=${MYSQL_GRAFANA_PW}

# Database Defaults
ENV INFLUXDB_GRAFANA_DB datasource
ENV INFLUXDB_GRAFANA_USER datasource
ENV INFLUXDB_GRAFANA_PW datasource

# Fix bad proxy issue
COPY system/99fixbadproxy /etc/apt/apt.conf.d/99fixbadproxy

# Clear previous sources
RUN rm /var/lib/apt/lists/* -vf

# Base dependencies
RUN apt-get -y update && \
 apt-get -y dist-upgrade && \
 apt-get -y install \
  apt-utils \
  ca-certificates \
  curl \
  git \
  htop \
  gnupg \
  libfontconfig \
  mysql-client \
  mysql-server \
  nano \
  net-tools \
  openssl \
  supervisor \
  wget \
  adduser \
  ntp \
  libfontconfig1 && \
 curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
 apt-get install -y nodejs

# Configure Supervisord and base env
COPY supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /root

RUN mkdir -p /var/log/supervisor && rm -rf .profile

COPY bash/profile .profile

# Configure MySql
COPY scripts/setup_mysql.sh /tmp/setup_mysql.sh

RUN /tmp/setup_mysql.sh

# Start NTP
COPY scripts/start_ntp.sh /tmp/start_ntp.sh

RUN /tmp/start_ntp.sh

# Install InfluxDB
RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_${ARCH}.deb && \
	dpkg -i influxdb_${INFLUXDB_VERSION}_${ARCH}.deb && rm influxdb_${INFLUXDB_VERSION}_${ARCH}.deb

# Configure InfluxDB
COPY influxdb/influxdb.conf /etc/influxdb/influxdb.conf
COPY influxdb/init.sh /etc/init.d/influxdb

COPY scripts/setup_influx.sh /tmp/setup_influx.sh

RUN /tmp/setup_influx.sh

# # Install Telegraf
# RUN wget https://dl.influxdata.com/telegraf/releases/telegraf_${TELEGRAF_VERSION}_${ARCH}.deb && \
# 	dpkg -i telegraf_${TELEGRAF_VERSION}_${ARCH}.deb && rm telegraf_${TELEGRAF_VERSION}_${ARCH}.deb

# # Configure Telegraf
# COPY telegraf/telegraf.conf /etc/telegraf/telegraf.conf
# COPY telegraf/init.sh /etc/init.d/telegraf

# Install chronograf
RUN wget https://dl.influxdata.com/chronograf/releases/chronograf_${CHRONOGRAF_VERSION}_${ARCH}.deb && \
  dpkg -i chronograf_${CHRONOGRAF_VERSION}_${ARCH}.deb

# Install Grafana

RUN wget https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_amd64.deb && \
	dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb && rm grafana_${GRAFANA_VERSION}_amd64.deb

# Configure Grafana with provisioning
ADD grafana/provisioning /etc/grafana/provisioning
ADD grafana/dashboards /var/lib/grafana/dashboards
COPY grafana/grafana.ini /etc/grafana/grafana.ini

COPY scripts/make_certs.sh /tmp/make_certs.sh

RUN /tmp/make_certs.sh

# Cleanup
RUN apt-get clean && \
 rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/bin/supervisord"]
