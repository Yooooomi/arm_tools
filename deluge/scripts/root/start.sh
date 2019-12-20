#!/bin/bash

echo Root starting...

chown user:user -R /downloads
chown user:user -R /config
chown user:user -R /home/user

source /root/openvpn.sh