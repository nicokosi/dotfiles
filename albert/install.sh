curl https://build.opensuse.org/projects/home:manuelschneid3r/public_key | sudo apt-key add -

apt update
apt install albert

echo "Installing albert extensions..."
extensions_dir="$HOME/.local/share/albert/org.albert.extension.externalextensions/extensions"
python_dir="$HOME/.local/share/albert/org.albert.extension.python/modules"
mkdir --parents $extensions_dir
mkdir --parents python_dir

git clone git@github.com:albertlauncher/external.git $entensions_dir
git clone git@github.com:albertlauncher/python.git $python_dir
git clone git@github.com:marek-mazur/albert-spell-extension.git $extensions_dir

chmod +x "$python_dir/*.sh"

# Add 'spell' extension (usage example: 'spell en great')
echo "Installing 'spell' dependencies..."
apt install xclip aspell aspell-en aspell-fr
echo "Installing 'spell' dictionaries..."
mkdir -p ~/.local/share/albert/external/spell
aspell -l en dump master | aspell -l en expand > ~/.local/share/albert/external/spell/en.dict
aspell -l fr dump master | aspell -l fr expand > ~/.local/share/albert/external/spell/fr.dict
echo "Installing 'spell' extension..."
chmod +x "$extensions_dir/Spell/__init__.py"

# Launch Albert on startup
cp --force /usr/share/applications/albert.desktop $HOME/.config/autostart/ && chmod +x $HOME/.config/autostart/albert.desktop
