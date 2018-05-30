#!/bin/bash

CONSUL_PORT=${CONSUL_PORT:-8500}
CONSUL_HOST=${CONSUL_HOST:consul}
CONSUL_SCHEME=${CONSUL_SCHEME:-http}
CONSUL_ADDR=${CONSUL_SCHEME}://${CONSUL_HOST}:${CONSUL_PORT}
CONSUL_LOCK_KEY=${CONSUL_LOCK_KEY:-vegadns-update-data-lock}
CONSUL_TOKEN=${CONSUL_TOKEN:-""}
CONSUL_VERIFY_SSL=${CONSUL_VERIFY_SSL:-true} # true or false

# Set up environment args
echo ${CONSUL_VERIFY_SSL} | grep -i false > /dev/null
if [ $? -eq 0 ]; then
    export CONSUL_HTTP_SSL_VERIFY=0
fi

# Set up cli args
TOKEN_ARG=""
if [ ! -z "${CONSUL_TOKEN}" ]; then
    TOKEN_ARG="-token=${CONSUL_TOKEN}"
fi

consul lock \
    ${TOKEN_ARG} \
    -http-addr=${CONSUL_ADDR} \
    -timeout=10s \
    -child-exit-code \
    ${CONSUL_LOCK_KEY} \
    /etc/update-data.sh
