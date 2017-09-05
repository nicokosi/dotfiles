GREEN='\033[0;32m'
NO_COLOR='\033[0m'

echo "${GREEN}Install packages to allow apt to use a repository over HTTPS${NO_COLOR}:"
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

echo "${GREEN}Add Docker’s official GPG key${NO_COLOR}:"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "${GREEN}Set up the stable repository${NO_COLOR}:"
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update

echo "${GREEN}Install docker-ce${NO_COLOR}:"
apt-get install docker-ce

echo "${GREEN}Install docker-compose${NO_COLOR}:"
dockerComposeVersion="1.16.1"
curl -L https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-`uname
-s`-`uname -m` -o /usr/local/bin/docker-compose
