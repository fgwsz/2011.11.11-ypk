#!/bin/bash

root_path=$(dirname "$(readlink -f "$0")")
echo "You Can Input q For Abort."
read -p "Input Git Commit Info: " commit_info
if [ "$commit_info" != "q" ]; then
    cd "$root_path"
    git add "2011.11.11.cdb"
    git add "script"/*
    git add "ocg"/*
    git add "DataEditorX"/*
    git add README.md
    git add git-push.ps1
    git add git-push.sh
    git add update-script.ps1
    git add update-script.sh
    git add create-ypk.ps1
    git add create-ypk.sh
    git add script-card-list.txt
    git add series-change-list.txt
    git add change-log.txt
    git add .gitignore
    git commit -m "$commit_info"
    git push
fi
