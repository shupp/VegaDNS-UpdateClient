#!/bin/bash

CONSUL_KEY=${CONSUL_KEY:-VEGADNS-CHANGES}

# Prep consul-template config file config
sed -i "s/@@KEY@@/${CONSUL_KEY}/" /etc/consul-template.in.tpl

exec "$@"
