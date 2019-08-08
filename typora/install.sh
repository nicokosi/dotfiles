# or run:
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE

wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -

# add Typora's repository
add-apt-repository 'deb https://typora.io/linux ./'

apt-get update

# install typora
apt-get install typora
