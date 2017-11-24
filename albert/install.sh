sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_17.10/ /' > /etc/apt/sources.list.d/albert.list"
apt-get update
apt-get install albert

git clone git@github.com:albertlauncher/external.git "$HOME/.local/share/albert/external/"

extensions_dir="$HOME/.local/share/albert/org.albert.extension.externalextensions/extensions"

# Add 'spell' extension (usage example: 'spell en great')
echo "Installing 'spell' dependencies..."
apt install xclip aspell aspell-en aspell-fr
echo "Installing 'spell' dictionaries..."
mkdir -p ~/.local/share/albert/external/spell
aspell -l en dump master | aspell -l en expand > ~/.local/share/albert/external/spell/en.dict
aspell -l fr dump master | aspell -l fr expand > ~/.local/share/albert/external/spell/fr.dict
echo "Installing 'spell' extension..."
mkdir --parents $extensions_dir
wget "https://raw.githubusercontent.com/albertlauncher/external/master/spell.py" --directory-prefix $extensions_dir
chmod +x "$extensions_dir/spell.py"
