#!/bin/bash

root_path=$(dirname "$(readlink -f "$0")")
today=$(date +%Y%m%d)

cd "$root_path"
rm -rf ./706-*.ypk
cp "utility.lua" "script/"
zip -r "706-$today.ypk" "706.cdb" "script"
rm -rf "script/utility.lua"
