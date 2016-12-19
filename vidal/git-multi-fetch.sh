#!/bin/bash

echo "git fetch" ;
for rep in 'arthur' 'perceval' 'zapi-native' 'perceval-installer' 'cdrom-installer' 'zapi-sdk' 'api-installer';
do
  echo "$rep ✔" ;
  git --git-dir="/home/nkosinski/work/$rep/.git" fetch
done
