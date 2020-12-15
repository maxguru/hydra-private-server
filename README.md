# Hydra Private Server

Let's say you have a hidden server behind firewalls (or NAT) that you want to make publicly reachable on the Internet via a number of short-lived Debian-based "reverse-proxy" VPSes.

## Initial target setup

Clone this repo on the target system (where you have hidden services running).

Run setup to initialize settings,
```
# ./setup_target.sh <target VPN interface IP> <target VPN interface netmask>
```
This generates `config.sh`, `fastd.conf`.

Example,
```
# ./setup_target.sh 192.168.95.1 255.255.255.0
```

## Add a proxy

This will auto-configure a blank VPS with SSH server (on port 22) for proxying tcp/udp ports (except 22 and 10000) to the target.
```
# ./setup_proxy.sh <public VPS IP>
```
This will install packages on the server, set up firewall, fastd and iptables rules.  This also creates a config file in the `peers` directory.

Example,
```
# ./setup_proxy.sh "1.2.3.4"
```

## Run VPN damon on target

Run the `fastd` daemon,
```
# ./run_target_daemon.sh
```
This will connect out to proxies.

## Remove a proxy

```
# ./teardown_proxy.sh "1.2.3.4"
```

## Remove target configuration

```
# ./teardown_target.sh
```
