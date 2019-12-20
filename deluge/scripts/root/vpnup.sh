#!/bin/bash

echo VPN is UP !

docker_int=$(ifconfig | grep -vE "lo|tun|tap" | head -n 1 | cut -d : -f 1)
docker_ip=$(ifconfig "$docker_int" | grep inet -m 1 | sed -e "s/\s\s\+/ /g" | cut -d ' ' -f 3)

default_route=$(ip route show default | awk '/default/ {print $3}')

local_network="${LOCAL_NETWORK}"

export IFS=","
if [ ! -z "$local_network" ]
then
    for address in $local_network
    do
        echo "Adding $address to Docker ip ($docker_ip)"
        /sbin/ip route add "$address" via "$default_route" dev "$docker_int"
    done
fi

echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

source /root/all_setup.sh