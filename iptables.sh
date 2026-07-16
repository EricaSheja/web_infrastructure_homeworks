#!/bin/bash

set -e

LB01_IP="172.20.0.10"

iptables -F INPUT
iptables -X 2>/dev/null || true

#deny inbound and leave outbound open
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 1. Allow HTTP only from lb-01
iptables -A INPUT -p tcp --dport 80 -s "$LB01_IP" -j ACCEPT

# 2. Allow SSH from anywhere
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# 3. Allow HTTPS from anywhere
iptables -A INPUT -p tcp --dport 443 -j ACCEPT