$root_path = Split-Path -Parent $MyInvocation.MyCommand.Path
cd "$root_path"
git diff --no-index `
    "$root_path\specials\706\special.lua" `
    "$root_path\special.lua"
