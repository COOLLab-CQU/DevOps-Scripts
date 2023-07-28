#!/bin/sh

# Author:   howboring (Boyu Hou), NASG@COOLab
# Date:     2022/03/14
# Note:     All our servers are under 10.239.3.0/24 network segment.

# ----

#!/bin/bash

. clean.sh

GATEWAY=$(/sbin/ip route | awk '/default/ { print $3 }')
MAIN_IF=$(/sbin/ip route | awk '/default/ { print $5 }')
TUN_IP=198.18.0.1

echo 'Please note that the proxy must use the socks5 protocol.'

if [[ $1 ]]; then
    proxy=$1
else
    read -p 'Input the proxy information: (your.ip.addr:port) > ' proxy
fi

ip tuntap add mode tun dev tun0
ip addr add ${TUN_IP}/16 dev tun0
ip link set dev tun0 up

echo 'TUN adapter is setted.'

setsid tun2socks -device tun://tun0 -interface ${MAIN_IF} -proxy socks5://${proxy} &>/tmp/tun2sokcs.log &

ip route del default
ip route add default via ${TUN_IP} dev tun0 metric 10
ip route add default via ${GATEWAY} dev ${MAIN_IF} metric 100

# ip route add 219.221.96.0/19 via ${GATEWAY}
# ip route add 172.16.0.0/12 via ${GATEWAY}

ip route add 219.221.96.0/19 via ${GATEWAY}
ip route add 172.16.0.0/12 via ${GATEWAY}
ip route add 10.0.0.0/8 via ${GATEWAY}

echo 'Connection succesful, all done.'
