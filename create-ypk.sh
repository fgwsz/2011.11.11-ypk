#!/bin/bash

# 获取脚本所在目录的绝对路径
root_path=$(dirname "$(readlink -f "$0")")
# 获取当前日期
today=$(date +%Y.%m.%d)

cd "$root_path"
rm -rf ./*.ypk
zip -r "2011.11.11-电脑手机录像播放三合一通用补丁（$today）.ypk" "2011.11.11.cdb" "script"
