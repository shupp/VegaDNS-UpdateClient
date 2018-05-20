#!/bin/bash

# For real time push notifications

CONSUL_PORT=${CONSUL_PORT:-8500}
CONSUL_HOST=${CONSUL_HOST:consul}
CONSUL_ADDR=${CONSUL_HOST}:${CONSUL_PORT}

consul-template \
    -consul-addr=${CONSUL_ADDR} \
    -template "/etc/consul-template.in.tpl:/dev/null:consul lock -http-addr=http://${CONSUL_ADDR} -timeout=10s -child-exit-code vegadns-update-data-lock /etc/update-data.sh"
