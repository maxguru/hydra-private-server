#!/bin/bash -e

PROXY_IP="${1}"

ssh "root@${PROXY_IP}" "bash -s" < ./proxy_teardown_script.sh

sudo sed "/# ---- ${PROXY_IP} >>>>/,/# <<<< ${PROXY_IP} ----/d" /etc/wireguard/hydra.conf > out
sudo mv out /etc/wireguard/hydra.conf

sudo systemctl restart wg-quick@hydra.service
