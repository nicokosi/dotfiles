#!/bin/zsh

cd /tmp
wget --quiet https://github.com/npryce/adr-tools/archive/3.0.0.zip
unzip -q 3.0.0.zip
mv "/tmp/adr-tools-3.0.0" ~
echo "adr-tools installed in `ls --directory ~/adr-tools-3.0.0`"
