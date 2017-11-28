add-apt-repository ppa:hluk/copyq
apt update
apt install copyq

cp /usr/share/applications/copyq.desktop $HOME/.config/autostart/ && chmod +x $HOME/.config/autostart/copyq.desktop

