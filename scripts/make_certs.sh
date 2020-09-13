#!/bin/bash
set -euo pipefail
mkdir -p /etc/secrets
openssl req -x509 -newkey rsa:4096 -keyout /etc/secrets/gf_key.pem -out /etc/secrets/gf_cert.pem -days 365 -nodes -subj '/CN=localhost'