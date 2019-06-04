#!/bin/bash

function sync_gitignore() {
    MESSAGE="Synced with modified gitignore file."
    if [ $# = 1 ]; then
	if [[ $1 = *-h* ]]; then
	    echo "sync_gitignore <COMMIT MESSAGE>"
	    return 1
	else
	    MESSAGE=$1	    
	fi
    else
	echo "Using 'Synced with modified gitignore file.' as commit message."
    fi

    git rm -r --cached .
    git add -A
    git commit -m "$MESSAGE"
    
    return 0
}
