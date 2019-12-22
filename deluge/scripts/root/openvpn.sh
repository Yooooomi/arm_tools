#!/bin/bash

# If the VPN is enabled then launch openvpn
if [ "$VPN_ENABLED" == "yes" ]
then
    echo "$VPN_USER" > /config/openvpn/credentials.conf
    echo "$VPN_PASS" >> /config/openvpn/credentials.conf

    config_file="/config/openvpn/config.ovpn"

    if [[ "$VPN_PROVIDER" == "NORDVPN" ]]
    then
        vpn_server=$(curl --silent "https://api.nordvpn.com/v1/servers/recommendations?filters\[servers_groups\]\[identifier\]=legacy_p2p&limit=1" | jq '.[].hostname' --raw-ouput)
        echo "NordVPN provider, will use ${vpn_server} instead of config.ovpn"
        config_file="/config/openvpn/${vpn_server}.ovpn"
        curl "https://downloads.nordcdn.com/configs/files/ovpn_legacy/servers/${vpn_server}.udp1194.ovpn" > $config_file
    fi

    openvpn                                                 \
    --config "$config_file"                                 \
    --auth-user-pass /config/openvpn/credentials.conf       \
    --script-security 2 --up /root/vpnup.sh                 \
    --setenv LOCAL_NETWORK "${LOCAL_NETWORK}"
else
    source /root/all_setup.sh
fi
