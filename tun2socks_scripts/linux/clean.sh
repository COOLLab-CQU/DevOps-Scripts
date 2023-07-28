#!/bin/sh

# Author:   howboring (Boyu Hou), NASG@COOLab
# Date:     2022/03/14
# Note:     All our servers are under 10.239.3.0/24 network segment.

# ----

#!/bin/bash

GATEWAY=$(/sbin/ip route list metric 10 | awk '/default/ { print $3 }')
MAIN_IF=$(/sbin/ip route list metric 10 | awk '/default/ { print $5 }')
TUN_IP=198.18.0.1

function clean () {
    pkill tun2socks

    if [[ -z "${GATEWAY}" || -z "${MAIN_IF}" ]]; then
        return 0
    fi

    IFS=$'\n'
    for record in $(/sbin/ip -o -4 route show via ${GATEWAY}); do
        cmd="ip route del ${record:0:-1} via ${GATEWAY}"
        echo "$cmd"
        bash -c "$cmd"

    done

    ip link show dev tun0 &>/dev/null
    if [[ $? -eq 0 ]]; then
        echo 'Removing previous TUN adapter...'
        ip tuntap del mode tun dev tun0
    fi

    ip route add default via ${GATEWAY} dev ${MAIN_IF}

    echo 'Cleaned.'
}


clean
