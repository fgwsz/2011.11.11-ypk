#!/bin/bash
set -e  # 遇到错误立即退出

# 获取脚本所在目录的绝对路径
root_path=$(dirname "$(readlink -f "$0")")
specials_path="$root_path/specials"
target_path="$root_path/script"  # 父仓库中存放同步内容的目录

# 1. 克隆/更新外部仓库
if [ ! -d "$specials_path" ]; then
    echo "克隆外部仓库..."
    git clone git@github.com:purerosefallen/specials "$specials_path"
else
    echo "更新外部仓库..."
    cd "$specials_path"
    git pull
fi

# 2. 确保外部仓库中有 706 文件夹
if [ ! -d "$specials_path/706" ]; then
    echo "错误：外部仓库中不存在 706 文件夹"
    exit 1
fi

# 3. 同步 706 文件夹到父仓库的对应位置
echo "同步 706 文件夹到父仓库..."
# 先清理旧内容（可选，确保完全镜像外部文件夹）
rm -rf "$target_path"
# 复制新内容
cp -r "$specials_path/706" "$target_path"

# 4. 提交变更到父仓库
cd "$root_path"
git add -A "$target_path"  # -A 会处理新增、修改、删除
# 检查是否有变更需要提交
if git diff --cached --quiet; then
    echo "没有检测到变更，无需提交。"
else
    git commit -m "自动同步 external/specials 的 706 文件夹"
    git push
    echo "同步完成并已推送。"
fi
