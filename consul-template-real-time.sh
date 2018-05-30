#!/bin/bash

# For real time push notifications

CONSUL_PORT=${CONSUL_PORT:-8500}
CONSUL_HOST=${CONSUL_HOST:consul}
CONSUL_SCHEME=${CONSUL_SCHEME:-http}
CONSUL_ADDR=${CONSUL_HOST}:${CONSUL_PORT}
CONSUL_LOCK_KEY=${CONSUL_LOCK_KEY:-vegadns-update-data-lock}
CONSUL_TOKEN=${CONSUL_TOKEN:-""}
CONSUL_VERIFY_SSL=${CONSUL_VERIFY_SSL:-true} # true or false

# Set up cli args
TOKEN_ARG=""
if [ ! -z "${CONSUL_TOKEN}" ]; then
    TOKEN_ARG="-consul-token=${CONSUL_TOKEN}"
fi

SSL_ARG=""
SSL_VERIFY_ARG=""
if [ "${CONSUL_SCHEME}" = "https" ]; then
    SSL_ARG="-consul-ssl"
    # Set verify arg
    echo ${CONSUL_VERIFY_SSL} | grep -i false > /dev/null
    if [ $? -eq 0 ]; then
        SSL_VERIFY_ARG="-consul-ssl-verify=false"
    fi
fi


consul-template \
    ${TOKEN_ARG} \
    ${SSL_ARG} \
    ${SSL_VERIFY_ARG} \
    -consul-addr=${CONSUL_ADDR} \
    -template "/etc/consul-template.in.tpl:/dev/null:/etc/consul-lock-update-data.sh"
