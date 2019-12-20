#!/bin/bash

echo User starting...

while [ ! -f /home/user/vpnup ]
do
    sleep 0.1
done

echo User detected that VPN is UP !

if [[ -f /config/deluged.pid ]]
then
    echo "Found deluged.pid, removing..."
    rm /config/deluged.pid
fi

if [[ ! -f /config/web.conf ]]; then
	echo "Deluge-web config file doesn't exist, copying default..."
	cp /home/user/defaults/web.conf /config/
fi


# if deluge config file doesnt exist then copy stock config file
if [[ ! -f /config/core.conf ]]; then
	echo "Deluge config file doesn't exist, copying default..."
	cp /home/user/defaults/core.conf /config/
fi

if [ ! -d "/downloads/torrents" ]
then
    mkdir "/downloads/torrents"
fi
if [ ! -d "/downloads/downloaded" ]
then
    mkdir "/downloads/downloaded"
fi
if [ ! -d "/downloads/current" ]
then
    mkdir "/downloads/current"
fi

/usr/bin/deluged --config /config && sleep 3 && /usr/bin/deluge-web --config /config
