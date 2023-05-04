#!/bin/bash -e

VPN_MY_IP="${1}"
VPN_CIDR="${2}"
VPN_MY_IP6="${3}"
VPN_CIDR6="${4}"

# check to make sure dependencies are installed on target
which wg
which sudo

MY_PRIVATE_KEY=$(wg genkey)
MY_PUBLIC_KEY=$(echo $MY_PRIVATE_KEY | wg pubkey)

cat >config.sh <<EOL

MY_PRIVATE_KEY="${MY_PRIVATE_KEY}"
MY_PUBLIC_KEY="${MY_PUBLIC_KEY}"

VPN_MY_IP="${VPN_MY_IP}"
VPN_CIDR="${VPN_CIDR}"
VPN_MY_IP6="${VPN_MY_IP6}"
VPN_CIDR6="${VPN_CIDR6}"

EOL

sudo mkdir -p /etc/wireguard
sudo cat >/etc/wireguard/hydra.conf <<EOL

[Interface]
PrivateKey = ${MY_PRIVATE_KEY}
Address = ${VPN_MY_IP}/${VPN_CIDR}, ${VPN_MY_IP6}/${VPN_CIDR6}
ListenPort = 1000
Table = off

EOL

sudo systemctl enable wg-quick@hydra.service
sudo systemctl start wg-quick@hydra.service
