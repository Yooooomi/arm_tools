#!/bin/bash

# If the VPN is enabled then launch openvpn
if [ "$VPN_ENABLED" == "yes" ]
then
    echo "$VPN_USER" > /config/openvpn/credentials.conf
    echo "$VPN_PASS" >> /config/openvpn/credentials.conf

    openvpn                                                 \
    --config /config/openvpn/config.ovpn                    \
    --auth-user-pass /config/openvpn/credentials.conf       \
    --script-security 2 --up /root/vpnup.sh                 \
    --setenv LOCAL_NETWORK "${LOCAL_NETWORK}"
else
    source /root/all_setup.sh
fi
