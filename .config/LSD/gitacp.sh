#!usr/bin/env bash

status=$(git status -s)

if [ ! -z "$status" ]; then
    diff="$(git diff)"
    if [ ! -z "$diff" ]; then
        echo "$diff" | bat
    else
        git status | bat
    fi
    read -p "message: " message
    read -p "Confirm (y|N): " confirm

    if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
        git add . && status=$(git status -s) && git commit -m "$message" -m "$status" && git push -u origin main
    else    
        echo "See Ya..."
    fi

else
    echo "Nothing to commit." | bat
fi
