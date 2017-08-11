apt-get install albert

add-apt-repository ppa:nilarimogard/webupd8
apt-get update
apt-get install albert

git clone git@github.com:albertlauncher/external.git "$HOME/.local/share/albert/external/"

# Add spell extension (usage example: 'spell en great')
wget https://raw.githubusercontent.com/albertlauncher/external/master/org.albert.extension.external.spell.py -P "$HOME/.local/share/albert/external/"
