#!/bin/bash
# Reenvío de paquetes y NAT del servidor VPN (192.168.1.10).
# Los clientes VPN (10.8.0.0/24) salen hacia la DMZ con la IP del servidor,
# que es la única que FW2 deja llegar al proxy (TCP 3128).
# Uso: sudo ./vpn-nat.sh [interfaz]   (por defecto enp0s3)
set -euo pipefail

IFACE="${1:-enp0s3}"

sysctl -w net.ipv4.ip_forward=1
grep -q '^net.ipv4.ip_forward=1' /etc/sysctl.conf || echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

iptables -t nat -C POSTROUTING -s 10.8.0.0/24 -o "$IFACE" -j MASQUERADE 2>/dev/null \
  || iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o "$IFACE" -j MASQUERADE

# Hacer la regla persistente tras reiniciar: sudo apt install iptables-persistent && sudo netfilter-persistent save
iptables -t nat -L POSTROUTING -n -v
