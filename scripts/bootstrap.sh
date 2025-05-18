#!/usr/bin/env bash
set -e

apt-get update
apt-get install -y wireguard

mkdir -p /etc/wireguard
cd /etc/wireguard

wg genkey | tee server_private.key | wg pubkey > server_public.key

cat > wg0.conf <<EOF
[Interface]
Address = 10.0.10.1/24
ListenPort = ${WG_PORT:-51820}
PrivateKey = $(cat server_private.key)
EOF

sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

wg-quick up wg0
systemctl enable wg-quick@wg0

#Installs WireGuard, generates server keys, writes /etc/wireguard/wg0.conf, enables IP forwarding and brings up the tunnel.

