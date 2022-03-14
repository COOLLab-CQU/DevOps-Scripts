#!/bin/sh

# Author:   howboring (Boyu Hou), NASG@COOLab
# Date:     2022/03/14
# Note:     All our servers are under 172.20.161.0/24 network segment.

# ----

source clean.sh

echo 'Please note that the proxy must use the socks5 protocol.'

if [[ $1 ]]; then
    proxy=$1
else
    read -p 'Input the proxy information: (your.ip.addr:port) > ' proxy
fi

ip tuntap add mode tun dev tun0
ip addr add 10.4.0.2/24 dev tun0
ip link set dev tun0 up

echo 'TUN adapter is setted.'

setsid tun2socks -device tun://tun0 -proxy socks5://${proxy} &>/tmp/tun2sokcs.log &

ip route replace default dev tun0 &&
    ip route add 219.221.96.0/19 via 172.20.161.1 &&
    ip route add 172.16.0.0/12 via 172.20.161.1

if [[ $? -eq 0 ]]; then
    echo 'Connection succesful, all done.'
else
    echo 'Error occured, cleaning...'
    source clean.sh
fi
