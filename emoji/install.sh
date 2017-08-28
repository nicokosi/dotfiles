# Do not install from package manager since version is too old
# and does not contain this feature:
# "Global hotkey support via socket:"
#https://github.com/gentakojima/emojione-picker-ubuntu/commit/9a4c6d0e6dbc5daab2c534d53996ceb7d1d5d26f
#add-apt-repository ppa:ys/emojione-picker
#apt-get update
#sudo apt-get install emojione-picker

cd
git clone https://github.com/gentakojima/emojione-picker-ubuntu
cd emojione-picker-ubuntu
./install.sh
