#!/bin/bash

# exit script if return code != 0
set -e

echo 'Server = http://mirror.archlinuxarm.org/$arch/$repo'  > /etc/pacman.d/mirrorlist

echo "[info] content of arch mirrorlist file"
cat /etc/pacman.d/mirrorlist

# reset gpg (not required when source is bootstrap tarball, but keeping for historic reasons)
rm -rf /etc/pacman.d/gnupg/ /root/.gnupg/ || true

# refresh gpg keys
gpg --refresh-keys

# initialise key for pacman and populate keys 
pacman -Sy archlinuxarm-keyring  --noconfirm
pacman-key --init && pacman-key --populate archlinuxarm

# force use of protocol http and ipv4 only for keyserver (defaults to hkp)
echo "no-greeting" > /etc/pacman.d/gnupg/gpg.conf
echo "no-permission-warning" >> /etc/pacman.d/gnupg/gpg.conf
echo "lock-never" >> /etc/pacman.d/gnupg/gpg.conf
echo "keyserver hkp://ipv4.pool.sks-keyservers.net" >> /etc/pacman.d/gnupg/gpg.conf
echo "keyserver-options timeout=10" >> /etc/pacman.d/gnupg/gpg.conf

# refresh keys for pacman
pacman-key --refresh-keys

# update packages currently installed
pacman -Syu --noconfirm

# install grep package (used to do exclusions)
pacman -S grep --noconfirm

# install base group packages with exclusions
pacman -S $(pacman -Sgq base | \
grep -v filesystem | \
grep -v cryptsetup | \
grep -v device-mapper | \
grep -v dhcpcd | \
grep -v iproute2 | \
grep -v jfsutils | \
grep -v libsystemd | \
grep -v linux | \
grep -v lvm2 | \
grep -v man-db | \
grep -v man-pages | \
grep -v mdadm | \
grep -v netctl | \
grep -v pciutils | \
grep -v pcmciautils | \
grep -v reiserfsprogs | \
grep -v s-nail | \
grep -v systemd | \
grep -v systemd-sysvcompat | \
grep -v usbutils | \
grep -v xfsprogs) \
 --noconfirm

# install additional packages
pacman -S awk sed supervisor nano vi ldns moreutils net-tools dos2unix unzip unrar htop jq openssl-1.0 --noconfirm

# set locale
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen
echo LANG="en_US.UTF-8" > /etc/locale.conf

# add user "nobody" to primary group "users" (will remove any other group membership)
usermod -g users nobody

# add user "nobody" to secondary group "nobody" (will retain primary membership)
usermod -a -G nobody nobody

# setup env for user nobody
mkdir -p /home/nobody
chown -R nobody:users /home/nobody
chmod -R 775 /home/nobody

# set user "nobody" home directory (needs defining for pycharm, and possibly other apps)
usermod -d /home/nobody nobody
 
# set shell for user nobody
chsh -s /bin/bash nobody

# find latest tini release tag from github
curl --connect-timeout 5 --max-time 600 --retry 5 --retry-delay 0 --retry-max-time 60 -o /tmp/tini_release_tag -L https://github.com/krallin/tini/releases
tini_release_tag=$(cat /tmp/tini_release_tag | grep -P -o -m 1 '(?<=/krallin/tini/releases/tag/)[^"]+')

# download tini, used to do graceful exit when docker stop issued and correct reaping of zombie processes.
curl --connect-timeout 5 --max-time 600 --retry 5 --retry-delay 0 --retry-max-time 60 -o /usr/bin/tini -L "https://github.com/krallin/tini/releases/download/${tini_release_tag}/tini-armhf" && chmod +x /usr/bin/tini

# cleanup
yes|pacman -Scc
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /usr/share/gtk-doc/*
rm -rf /root/*
rm -rf /tmp/*
