FROM linuxserver/deluge:arm32v7-latest

RUN apt-get update
RUN apt-get install openvpn supervisor inetutils-traceroute net-tools ipcalc -y

RUN mkdir /build
COPY build/root/* /build/

RUN sh /build/install.sh

COPY build/conf/supervisor.conf /etc/supervisor.conf

COPY scripts/root/* /root/
COPY scripts/user/* /home/user/

RUN mkdir /home/user/defaults
COPY build/conf/* /home/user/defaults/

ENV HOME /home/user
ENV TERM xterm
ENV LANG en_GB.UTF-8

ENTRYPOINT [ "supervisord", "-c", "/etc/supervisor.conf" ]