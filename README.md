# Hydra Private Server

Let's say you have a hidden server behind firewalls (or NAT) that you want to make publicly reachable on the Internet via a number of short-lived Debian-based "reverse-proxy" VPSes.

## Initial setup

Run on target,
```
# ./setup_target.sh <target VPN interface IP> <target VPN interface netmask> "<space separated port list>"
```
This generates `config.sh`.
Example,
```
# ./setup_target.sh 192.168.95.1 255.255.255.0 "80 443"
```

## Add a proxy

This will auto-configure a blank VPS with SSH server (on port 22) for proxying ports in `config.sh`.
```
# ./setup_proxy.sh <public VPS IP>
```
This will install packages on the server, set up firewall, fastd, iptables rules.
Example,
```
# ./setup_proxy.sh "1.2.3.4"
```

## Remove a proxy

```
# ./teardown_proxy.sh "1.2.3.4"
```

## Remove target configuration

```
# ./teardown_target.sh "1.2.3.4"
```
