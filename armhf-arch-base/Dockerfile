FROM forumi0721/arch-armhf-base:latest
MAINTAINER LedoKun

# additional files
##################

# add supervisor conf file
ADD build/*.conf /etc/supervisor.conf

# add install bash script
ADD build/root/*.sh /root/

# install app
#############

# For cross compile on dockerhub
RUN ["docker-build-start"]

# run bash script to update base image, set locale, install supervisor and cleanup
RUN chmod +x /root/*.sh && \
	/bin/bash /root/install.sh

# For cross compile on dockerhub
RUN ["docker-build-end"]

# env
#####

# set environment variables for user nobody
ENV HOME /home/nobody

# set environment variable for terminal
ENV TERM xterm

# set environment variables for language
ENV LANG en_US.UTF-8

# run
#####

# run tini to manage graceful exit and zombie reaping
ENTRYPOINT ["/usr/bin/tini", "--"]
