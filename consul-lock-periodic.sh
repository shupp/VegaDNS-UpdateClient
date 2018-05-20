#!/bin/bash

# This is just in case any race conditions creep up and we miss an update.
# Every 60 seconds, pull updates just in case.

CONSUL_PORT=${CONSUL_PORT:-8500}
CONSUL_HOST=${CONSUL_HOST:consul}
CONSUL_ADDR=${CONSUL_HOST}:${CONSUL_PORT}

TIMEOUT=60 # Time between cleanup runs

consul lock \
    -http-addr=http://${CONSUL_ADDR} \
    -timeout=10s \
    -child-exit-code \
    vegadns-update-data-lock \
    /etc/update-data.sh

sleep ${TIMEOUT}
