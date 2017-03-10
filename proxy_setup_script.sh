#!/bin/bash

AUTHORIZE_KEY="${1}"
MY_IP="${2}"
VPN_DMZ_IP="${3}"
VPN_MY_IP="${4}"
VPN_NETMASK="${5}"
MY_PRIVATE_KEY="${6}"
MY_PUBLIC_KEY="${7}"
TARGET_PUBLIC_KEY="${8}"

mkdir -p /root/.ssh && \
echo $AUTHORIZE_KEY > /root/.ssh/authorized_keys

apt-get update && \
apt-get -yq --no-install-recommends --no-install-suggests install ufw fastd && \
ufw allow 22/tcp && \
ufw allow 10000/udp && \
mkdir -p /etc/fastd/hydra/peers

if [ $? != 0 ]; then
	return 1;
fi

cat >/etc/fastd/hydra/fastd.conf <<EOL

# Log warnings and errors to stderr
log level fatal;

# Set the interface name
interface "hydra";

# Support salsa2012+umac and null methods, prefer salsa2012+umac
method "salsa2012+umac";

# Bind to a fixed port, IPv4 only
bind 0.0.0.0:10000;

# Secret key generated by 'fastd --generate-key'
secret "${MY_PRIVATE_KEY}";
# Public: ${MY_PUBLIC_KEY}

# Set the interface MTU for TAP mode with xsalsa20/aes128 over IPv4 with a base MTU of 1492 (PPPoE)
# (see MTU selection documentation)
mtu 1194;
mode tap;

# Include peers from the directory 'peers'
include peers from "peers";

on up sync "ifconfig hydra ${VPN_MY_IP} netmask ${VPN_NETMASK} up";
on down sync "ifconfig hydra down";

EOL

cat >/etc/fastd/hydra/peers/target.conf <<EOL
key "${TARGET_PUBLIC_KEY}";
EOL

update-rc.d fastd defaults
service fastd restart

cp /etc/ufw/before.rules /etc/ufw/before.rules.bak
cat >>/etc/ufw/before.rules <<EOL
# ---- GENERATED BY proxy_setup_script.sh >>>>
# NAT table
*nat
:POSTROUTING ACCEPT [0:0]
:PREROUTING ACCEPT [0:0]
# send all incoming tcp/udp traffic to target ip (except traffic for port 22 and 10000)
-A PREROUTING -d ${MY_IP} -p TCP -m multiport ! --dports 22,10000 -j DNAT --to-destination ${VPN_DMZ_IP}
-A PREROUTING -d ${MY_IP} -p UDP -m multiport ! --dports 22,10000 -j DNAT --to-destination ${VPN_DMZ_IP}
# masquerade everything sent to host ip and out of hydra interface (this is needed if the target is not using this host as a default gateway)
-A POSTROUTING --dst ${MY_IP} -o hydra -j MASQUERADE
# masquerade everything sent from target and out of eth0 interface (this is needed for target to use this host as a default gateway)
-A POSTROUTING --src ${VPN_DMZ_IP} -o eth0 -j MASQUERADE
COMMIT
# <<<< GENERATED BY proxy_setup_script.sh ----
EOL

cp /etc/default/ufw /etc/default/ufw.bak
cat >>/etc/default/ufw <<EOL
# ---- GENERATED BY proxy_setup_script.sh >>>>
DEFAULT_FORWARD_POLICY="ACCEPT"
# <<<< GENERATED BY proxy_setup_script.sh ----
EOL

cp /etc/ufw/sysctl.conf /etc/ufw/sysctl.conf.bak
cat >>/etc/ufw/sysctl.conf <<EOL
# ---- GENERATED BY proxy_setup_script.sh >>>>
net.ipv4.ip_forward=1
# <<<< GENERATED BY proxy_setup_script.sh ----
EOL

ufw --force enable
ufw reload
