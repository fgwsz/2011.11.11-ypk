$root_path=Split-Path -Parent $MyInvocation.MyCommand.Definition
echo "You Can Input q For Abort."
$commit_info=Read-Host -Prompt "Input Git Commit Info"
if(!($commit_info -eq "q")){
    cd $root_path
    git add "2011.11.11.cdb"
    git add "script"
    git add "ocg"
    git add "DataEditorX"
    git add "README.md"
    git add "git-push.ps1"
    git add "git-push.sh"
    git add "update-script.ps1"
    git add "update-script.sh"
    git add "create-ypk.ps1"
    git add "create-ypk.sh"
    git add "script-card-list.txt"
    git add "series-change-list.txt"
    git add "change-log.txt"
    git add ".gitignore"
    git commit -m $commit_info
    git push
}
