#!/bin/bash

if [ $# -lt 1 ]
  then
    echo "Missing argument: tag name."
    exit 1
fi
TAG_NAME="$1"

echo "Search tag(s) $TAG_NAME in repositories:"
for rep in 'arthur' 'perceval' 'zapi-native' 'perceval-installer' 'cdrom-installer' 'zapi-sdk' 'api-installer';
do
  echo "  $rep: " 
  git --git-dir="/home/nkosinski/work/$rep/.git" tag --column --list $TAG_NAME
done
