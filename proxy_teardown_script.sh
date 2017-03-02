#!/bin/bash

ufw disable && \
apt-get --autoclean remove ufw fastd && \
rm -rf /etc/fastd/hydra && \
rm /etc/ufw/after.rules && \
rm /root/.ssh/authorized_keys
