#!/bin/bash

# This is just in case any race conditions creep up and we miss an update.
# Every 60 seconds, pull updates just in case.

CONSUL_CLEANUP_TIMEOUT=${CONSUL_CLEANUP_TIMEOUT:-60} # Time between cleanup runs

/etc/consul-lock-update-data.sh

sleep ${CONSUL_CLEANUP_TIMEOUT}
