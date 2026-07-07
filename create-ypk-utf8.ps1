# 获取脚本所在目录的绝对路径
$root_path = Split-Path -Parent $MyInvocation.MyCommand.Path

# 获取当前日期，格式为 YYYY.MM.DD
$today = Get-Date -Format "yyyy.MM.dd"

# 切换到脚本所在目录
Set-Location $root_path

# 删除当前目录下所有 .ypk 文件（-Force 忽略错误，如文件不存在）
Remove-Item -Path ".\*.ypk" -Force -ErrorAction SilentlyContinue

# 打包文件：2011.11.11.cdb 和 script 目录，输出文件名包含日期
$zip_name = "2011.11.11.zip"
cp "utility.lua" "script"
Compress-Archive -Path "2011.11.11.cdb", "script" -DestinationPath $zip_name -Force
mv $zip_name "2011.11.11-电脑手机录像播放三合一通用补丁（$today）.ypk" -Force
cp "change-log.txt" "2011.11.11-补丁使用方式及更新记录（$today）.txt"
Remove-Item -Path "script\utility.lua" -Force -ErrorAction SilentlyContinue
