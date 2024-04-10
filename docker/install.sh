#!/bin/sh

# Fix "must run as sudo" issue:
groupadd docker
gpasswd -a "${USER}" docker

# Configure 'bridge' network IP and DNS for Vidal
echo "{
  \"bip\": \"10.10.10.1/24\",
  \"dns\": [\"172.16.50.4\", \"8.8.8.8\"]
}" > /etc/docker/daemon.json

service docker restart
