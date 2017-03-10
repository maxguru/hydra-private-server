#!/bin/bash

source config.sh

PROXY_IP="${1}"
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

COUNT=$(cat peercount 2>/dev/null)
COUNT=$(($COUNT+1))
echo $COUNT >peercount

VPN_PROXY_IP=$(echo $VPN_MY_IP | awk -F. "{printf \"%d.%d.%d.%d\", \$1,\$2,\$3,\$4+${COUNT}}")

FASTD_DATA=$(fastd --generate-key 2>/dev/null)
PROXY_PRIVATE_KEY=$(echo $FASTD_DATA|awk '{print $2}')
PROXY_PUBLIC_KEY=$(echo $FASTD_DATA|awk '{print $4}')

cat >"peers/${PROXY_IP}.conf" <<EOL
key "${PROXY_PUBLIC_KEY}";
remote "${PROXY_IP}":10000;
EOL

ssh "root@${PROXY_IP}" "bash -s" < ./proxy_setup_script.sh "'${SSH_KEY}'" "'${PROXY_IP}'" "'${VPN_MY_IP}'" "'${VPN_PROXY_IP}'" "'${VPN_NETMASK}'" "'${PROXY_PRIVATE_KEY}'" "'${PROXY_PUBLIC_KEY}'" "'${MY_PUBLIC_KEY}'"
