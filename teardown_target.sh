#!/bin/bash -e

sudo systemctl stop wg-quick@hydra.service
sudo systemctl disable wg-quick@hydra.service

sudo rm /etc/wireguard/hydra.conf
rm config.sh
