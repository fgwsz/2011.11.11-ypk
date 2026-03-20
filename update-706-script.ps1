#!/usr/bin/env pwsh
# 遇到错误立即退出（手动检查外部命令退出码）
$ErrorActionPreference = 'Stop'

# 获取脚本所在目录的绝对路径（兼容 PowerShell 3.0+）
$root_path = $PSScriptRoot
if (-not $root_path) {
    # 旧版本 PowerShell 的备用方法
    $root_path = Split-Path -Parent $MyInvocation.MyCommand.Path
}

$specials_path = Join-Path $root_path "specials"
$target_path   = Join-Path $root_path "706"

# 1. 克隆/更新外部仓库
if (-not (Test-Path $specials_path)) {
    Write-Host "克隆外部仓库..."
    git clone git@github.com:purerosefallen/specials $specials_path
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} else {
    Write-Host "更新外部仓库..."
    Push-Location $specials_path
    git pull
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Pop-Location
}

# 2. 确保外部仓库中有 706 文件夹
$source_706 = Join-Path $specials_path "706"
if (-not (Test-Path $source_706)) {
    Write-Host "错误：外部仓库中不存在 706 文件夹"
    exit 1
}

# 3. 同步 706 文件夹到父仓库的对应位置
Write-Host "同步 706 文件夹到父仓库..."
# 先清理旧内容（确保完全镜像）
if (Test-Path $target_path) {
    Remove-Item -Recurse -Force $target_path
}
# 复制新内容（自动创建 $root_path/706 目录）
Copy-Item -Recurse $source_706 $root_path -Force

# 4. 提交变更到父仓库
Push-Location $root_path
git add -A $target_path
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# 检查是否有变更需要提交（git diff --cached --quiet 返回 0 表示无变更，非0表示有变更）
git diff --cached --quiet
$has_changes = $LASTEXITCODE -ne 0
if (-not $has_changes) {
    Write-Host "没有检测到变更，无需提交。"
} else {
    git commit -m "自动同步 external/specials 的 706 文件夹"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    git push
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Write-Host "同步完成并已推送。"
}
Pop-Location
