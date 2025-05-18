#!/usr/bin/env bash
set -e

# 1. Install WireGuard
apt-get update
apt-get install -y wireguard

# 2. Generate server keys
mkdir -p /etc/wireguard
cd /etc/wireguard
wg genkey | tee server_private.key | wg pubkey > server_public.key

# 3. Write wg0.conf
cat > wg0.conf <<EOF
[Interface]
Address = 10.0.10.1/24
ListenPort = ${WG_PORT:-51820}
PrivateKey = $(cat server_private.key)

# Example peer (replace with actual client public key)
#[Peer]
#PublicKey = <CLIENT_PUBLIC_KEY>
#AllowedIPs = 10.0.10.2/32
EOF

# 4. Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

# 5. Start WireGuard
wg-quick up wg0
systemctl enable wg-quick@wg0
