#!/bin/bash

if [ $# -lt 1 ]
then
  echo "Missing arguments."
  echo " arg #1: git branch that should be merged (example: origin/2016.12)"
  exit 1
fi

BRANCH_TO_MERGE="$1"

for rep in 'arthur' 'perceval' 'zapi-native' 'perceval-installer' 'cdrom-installer' 'zapi-sdk' 'api-installer' ;
do
  echo "$rep: " ;
  git --git-dir="/home/nkosinski/work/$rep/.git" branch --remote --contains $BRANCH_TO_MERGE
done
