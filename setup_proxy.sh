#!/bin/bash -e

source config.sh

PROXY_IP="${1}"
VPN_PROXY_IP="${2}"
VPN_PROXY_IP6="${3}"

SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

PROXY_PRIVATE_KEY=$(wg genkey)
PROXY_PUBLIC_KEY=$(echo $PROXY_PRIVATE_KEY | wg pubkey)

sudo cat >>/etc/wireguard/hydra.conf <<EOL

# ---- ${PROXY_IP} >>>>
[Peer]
PublicKey = ${PROXY_PUBLIC_KEY}
Endpoint = ${PROXY_IP}:1000
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25
# <<<< ${PROXY_IP} ----

EOL

ssh "root@${PROXY_IP}" "bash -s" < ./proxy_setup_script.sh "'${SSH_KEY}'" "'${PROXY_IP}'" "'${PROXY_IP6}'" "'${VPN_MY_IP}'" "'${VPN_MY_IP6}'" "'${VPN_PROXY_IP}'" "'${VPN_CIDR}'" "'${VPN_PROXY_IP6}'" "'${VPN_CIDR6}'" "'${PROXY_PRIVATE_KEY}'" "'${PROXY_PUBLIC_KEY}'" "'${MY_PUBLIC_KEY}'"

sudo systemctl restart wg-quick@hydra.service
