# Exit immediately on errors (manual check for external command exit codes)
$ErrorActionPreference = 'Stop'

# Get the absolute path of the script directory
$root_path = Split-Path -Parent $MyInvocation.MyCommand.Path

$specials_path = Join-Path $root_path "specials"
$target_path   = Join-Path $root_path "script"

# 1. Clone / update the external repository
if (-not (Test-Path $specials_path)) {
    Write-Host "Cloning external repository..."
    git clone git@github.com:purerosefallen/specials $specials_path
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} else {
    Write-Host "Updating external repository..."
    Push-Location $specials_path
    git pull
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Pop-Location
}

# 2. Ensure the 706 folder exists in the external repository
$source_706 = Join-Path $specials_path "706"
if (-not (Test-Path $source_706)) {
    Write-Host "Error: The '706' folder does not exist in the external repository"
    exit 1
}

# 3. Synchronize the 706 folder to the corresponding location in the parent repository
Write-Host "Synchronizing the '706' folder to the parent repository..."
# Clean up old contents (to ensure a complete mirror)
if (Test-Path $target_path) {
    Remove-Item -Recurse -Force $target_path
}
# Copy new contents
Copy-Item -Recurse $source_706 $target_path -Force

# 4. Commit changes to the parent repository
Push-Location $root_path
git add -A $target_path
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Check if there are changes to commit (git diff --cached --quiet returns 0 if no changes, non-zero if changes)
git diff --cached --quiet
$has_changes = $LASTEXITCODE -ne 0
if (-not $has_changes) {
    Write-Host "No changes detected, nothing to commit."
} else {
    git commit -m "Auto-sync the '706' folder from external/specials"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    git push
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Write-Host "Synchronization completed and pushed."
}
Pop-Location
