#!/bin/sh

# Author:   howboring (Boyu Hou), NASG@COOLab
# Date:     2022/03/14
# Note:     All our servers are under 172.20.161.0/24 network segment.

# ----

pkill tun2socks

IFS=$'\n'
for record in $(ip route show via 172.20.161.1); do
    bash -c "ip route del ${record:0:-1} via 172.20.161.1"
done

ip link show dev tun0 &>/dev/null
if [[ $? -eq 0 ]]; then
    echo 'Removing previous TUN adapter...'
    ip tuntap del mode tun dev tun0
fi
