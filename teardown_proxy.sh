#!/bin/bash

PROXY="${1}"

rm "peers/${PROXY}.conf"
ssh "root@${PROXY}" "bash -s" < ./proxy_teardown_script.sh
