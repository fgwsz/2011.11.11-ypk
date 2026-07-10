#!/bin/bash

# update-utility_lua.sh
# 功能：将 ocg/utility.lua 的第一个 function 定义之前的内容作为头部，
#       之后的内容作为尾部，与 script/special.lua 及预加载代码组合生成新的 utility.lua。
#       各部分之间以空行分隔，并附带英文注释。
# 用法：可直接在项目根目录执行，也可从其他路径调用（脚本会自动切换到自身所在目录）。

set -euo pipefail

# 切换到脚本所在目录，保证后续相对路径正确
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 定义文件路径
OCG_UTILITY="ocg/utility.lua"
SPECIAL_LUA="script/special.lua"
OUTPUT_UTILITY="utility.lua"

# 检查必要文件是否存在
if [[ ! -f "$OCG_UTILITY" ]]; then
    echo "错误：找不到 $OCG_UTILITY" >&2
    exit 1
fi
if [[ ! -f "$SPECIAL_LUA" ]]; then
    echo "错误：找不到 $SPECIAL_LUA" >&2
    exit 1
fi

# 查找第一个 'function' 定义的行号（使用 POSIX 字符类，兼容所有 awk）
first_func_line=$(awk '/^[[:space:]]*function /{print NR; exit}' "$OCG_UTILITY")
if [[ -z "$first_func_line" ]]; then
    echo "错误：在 $OCG_UTILITY 中未找到 function 定义" >&2
    exit 1
fi

# ---- 生成新文件 ----
# 1. 第一部分：头部（第一个 function 之前的内容），附注释
{
    echo "-- Part 1: Head from ocg/utility.lua (before the first function)"
    sed -n "1,$((first_func_line - 1))p" "$OCG_UTILITY"
    echo   # 空行，用于分隔
} > "$OUTPUT_UTILITY"

# 2. 第二部分：script/special.lua 的全部内容，附注释
{
    echo "-- Part 2: Content from script/special.lua"
    cat "$SPECIAL_LUA"
    echo   # 空行，用于分隔
} >> "$OUTPUT_UTILITY"

# 3. 第三部分：预加载代码块，附注释
{
    echo "-- Part 3: Preload"
    echo "--exec Preload"
    echo "Auxiliary.PreloadUds()"
    echo   # 空行，用于分隔
} >> "$OUTPUT_UTILITY"

# 4. 第四部分：尾部（从第一个 function 开始到末尾），附注释
{
    echo "-- Part 4: Tail from ocg/utility.lua (from the first function onward)"
    sed -n "$first_func_line,\$p" "$OCG_UTILITY"
    # 尾部为最后一部分，不再追加多余空行
} >> "$OUTPUT_UTILITY"

echo "已成功生成 $OUTPUT_UTILITY"
