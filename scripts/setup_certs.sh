#!/bin/bash
set -euo pipefail

# Ensure directories exist
# mkdir -p "${HTTPS_CERT_DIR}"
# mkdir -p "${HTTPS_KEY_DIR}"

# Make the certificates
if [ ! -f ${HTTPS_CERT} ]
then
    openssl req -x509 -newkey rsa:4096 -keyout "${HTTPS_CERT_KEY}" -out "${HTTPS_CERT}" -days 365 -nodes -subj '/CN=localhost'
fi

chown root "${HTTPS_CERT_KEY}"
chgrp ssl-cert "${HTTPS_CERT_KEY}"
chmod 640 "${HTTPS_CERT_KEY}"

chmod 644 "${HTTPS_CERT}"


