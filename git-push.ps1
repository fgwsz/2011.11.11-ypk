$root_path=Split-Path -Parent $MyInvocation.MyCommand.Definition
echo "You Can Input q For Abort."
$commit_info=Read-Host -Prompt "Input Git Commit Info"
if(!($commit_info -eq "q")){
    cd $root_path
    #cards database
    git add "2011.11.11.cdb"
    git add "2011.11.11-reduce.cdb"
    git add "706.cdb"
    #706 script
    git add "script"
    #ocg files
    git add "ocg"
    #cards database editor
    git add "DataEditorX"
    #linux script
    git add "update-script.sh"
    git add "create-utility_lua.sh"
    git add "create-ypk.sh"
    git add "create-706-ypk.sh"
    git add "git-push.sh"
    #windows script
    git add "update-script.ps1"
    git add "create-utility_lua.ps1"
    git add "create-ypk-utf8.ps1"
    git add "create-ypk-cp936.ps1"
    git add "create-706-ypk.ps1"
    git add "git-push.ps1"
    #doc
    git add "series-change-list.txt"
    git add "effect-info-change-list.txt"
    git add "reduce-cards.txt"
    git add "change-log.txt"
    git add "README.md"
    #git files
    git add ".gitignore"
    git commit -m $commit_info
    git push
}
