#!/bin/bash

useradd user --create-home --shell /bin/bash

chown -R user:user /home/user

echo nameserver 8.8.8.8 >> /etc/resolv.conf
echo nameserver 8.8.4.4 >> /etc/resolv.conf