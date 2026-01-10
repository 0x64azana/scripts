#!/bin/bash
# ----------------------------------------------------------
# Script Name:     git-push.sh
# Description:     - Automates push to main from a local directory
# 		   - Very simple
# 		   - Edit as needed
# Author:          0x64azana
# Created:         2025-07-10
# Version:         1.0
# Usage:           ./git-push.sh
# # ----------------------------------------------------------
#!/bin/bash

cd "$HOME/Portfolio" || { 
    echo 'Project directory does not exist, please edit script.' 
    exit 1 
}

git add -A || { 
    echo '
Run through the initial steps of setting up git if you have not:
git config --global user.name "[username]"
git config --global user.email "[email]"
git init
'
    exit 1 
}

git commit -m 'Automated update'
git push origin main --force

