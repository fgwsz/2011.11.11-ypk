$root_path = Split-Path -Parent $MyInvocation.MyCommand.Path

$today = Get-Date -Format "yyyyMMdd"

Set-Location $root_path

Remove-Item -Path ".\*.ypk" -Force -ErrorAction SilentlyContinue

$zip_name = "706-$today.zip"
cp "utility.lua" "script"
Compress-Archive -Path "706.cdb", "script" -DestinationPath $zip_name -Force
mv $zip_name "706-$today.ypk" -Force
Remove-Item -Path "script\utility.lua" -Force -ErrorAction SilentlyContinue
