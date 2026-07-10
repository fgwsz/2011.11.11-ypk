<#
.SYNOPSIS
    Combines the head/tail of ocg/utility.lua, script/special.lua, and a preload snippet into a new utility.lua.
.DESCRIPTION
    The script automatically switches to its own directory, extracts everything before the first 'function'
    definition in ocg/utility.lua as the head, and everything from that line onward as the tail.
    It then assembles in this order:
    1. Head + blank line
    2. Full content of script/special.lua + blank line
    3. Preload block + blank line
    4. Tail
    Each part is prefixed with an English comment.
    All read/write operations use UTF-8 encoding (without BOM for output).
.NOTES
    File name: update-utility_lua.ps1
    Requires PowerShell 5.1 or later (PowerShell Core recommended).
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Change to the script's directory so relative paths work from any invocation
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $ScriptDir

# File paths
$OcgUtility = 'ocg/utility.lua'
$SpecialLua = 'script/special.lua'
$OutputUtility = 'utility.lua'

# Full output path (used for .NET write method)
$OutputFullPath = Join-Path -Path $ScriptDir -ChildPath $OutputUtility

# Check required files exist
if (-not (Test-Path $OcgUtility)) {
    Write-Error "Error: $OcgUtility not found"
    exit 1
}
if (-not (Test-Path $SpecialLua)) {
    Write-Error "Error: $SpecialLua not found"
    exit 1
}

# ---- Read all files with explicit UTF-8 encoding ----
$allLines = Get-Content -Path $OcgUtility -ReadCount 0 -Encoding UTF8
$specialLines = Get-Content -Path $SpecialLua -ReadCount 0 -Encoding UTF8

# Find the first 'function' definition line (ignoring leading whitespace)
$funcLine = $null
for ($i = 0; $i -lt $allLines.Count; $i++) {
    if ($allLines[$i] -match '^\s*function\s') {
        $funcLine = $i + 1   # 1‑based line number
        break
    }
}

if ($null -eq $funcLine) {
    Write-Error "Error: No 'function' definition found in $OcgUtility"
    exit 1
}

# Extract head (lines before the first function) and tail (from the function onward)
$headLines = $allLines[0..($funcLine - 2)]   # 0‑based indices
$tailLines = $allLines[($funcLine - 1)..($allLines.Count - 1)]

# Preload block
$preloadLines = @(
    '-- Part 3: Preload',
    '--exec Preload',
    'Auxiliary.PreloadUds()'
)

# Build the final output as a list of strings
$outputLines = [System.Collections.Generic.List[string]]::new()

# 1. Head
$outputLines.Add('-- Part 1: Head from ocg/utility.lua (before the first function)')
$outputLines.AddRange($headLines)
$outputLines.Add('')   # blank separator

# 2. special.lua
$outputLines.Add('-- Part 2: Content from script/special.lua')
$outputLines.AddRange($specialLines)
$outputLines.Add('')

# 3. Preload
$outputLines.AddRange($preloadLines)
$outputLines.Add('')

# 4. Tail
$outputLines.Add('-- Part 4: Tail from ocg/utility.lua (from the first function onward)')
$outputLines.AddRange($tailLines)

# ---- Write output as UTF-8 without BOM ----
[System.IO.File]::WriteAllLines(
    $OutputFullPath,
    $outputLines,
    [System.Text.UTF8Encoding]::new($false)   # $false = no BOM
)

Write-Host "Successfully generated $OutputUtility"
Pop-Location
