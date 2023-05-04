# Hydra Private Server

It may be advantageous to hide the true location of your publicly reachable server, have it behind firewalls (or NAT) or make it reachable via a number of short-lived Debian-based "reverse-proxy" VPSes. These bash scripts allow you to do just that.

One useful application of this project is to set up a personal home server that would be publically accessible.

## How it works

Traffic to all ports (except 22 and 1000) on proxies is DNAT-forwarded to the target via WireGuard interface.

## Requirements

### Target (hidden) server

- Debian
- wireguard
- sudo

### Proxy (public) server

- freshly instantiated Debian VPS

## Initial target setup

Clone this repo on the target system (where you have hidden services running).

Run setup to initialize settings,
```
# ./setup_target.sh "<target VPN interface IPv4>" "<target CIDRv4>" "<target VPN interface IPv6>" "<target CIDRv6>"
```

Example,
```
# ./setup_target.sh "192.168.95.1" "24" "fd95::1" "64"
```

This will create `/etc/wireguard/hydra.conf`, `./config.sh` and start/enable wireguard.

## Add a proxy

When you have your proxy server up and running, you can auto-configure it remotely. Make sure there is nothing important on it and it is a throw-away VPS.

```
# ./setup_proxy.sh <public VPS IP> <VPN interface IPv4> <VPN interface IPv6>
```

Example,
```
# ./setup_proxy.sh "1.2.3.4" "192.168.95.2" "fd95::2"
```

This will install packages on the server, set up firewall, wireguard and iptables rules.  This also creates a config file in the `/etc/wireguard` directory.

## Remove a proxy

```
# ./teardown_proxy.sh "1.2.3.4"
```

## Remove target configuration

```
# ./teardown_target.sh
```
