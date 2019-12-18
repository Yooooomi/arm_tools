**Froked from [binhex/arch-base](https://github.com/binhex/arch-base) to create an armhf image**

**Application**

[Arch Linux](https://www.archlinux.org/)

**Description**

Arch Linux is an independently developed, i686/x86-64 general purpose GNU/Linux distribution versatile enough to suit any role. Development focuses on simplicity, minimalism, and code elegance.

**Build notes**

Arch Linux base image using "arch-scratch" image from the [binhex repository](https://hub.docker.com/r/binhex/arch-scratch/). This image is set to a snapshot by using the archive.archlinux.org website for package updates, this is required to reduce image size by preventing rolling updates to packages.

**Notes**

This image includes Tini (https://github.com/krallin/tini) to ensure a clean shutdown and to correctly reap processes, Supervisor (http://supervisord.org/) is also installed to help monitor and run child processes.