#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Project
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 👨🏻‍💻
# @raycast.packageName Cloud Box
# @raycast.argument1 { "type": "text", "placeholder": "directory", "optional": true }

# Documentation:
# @raycast.description Allow current IP, update hosts, and open up a project
# @raycast.author Tyler Bodway
# @raycast.authorURL https://github.com/tylerbodway

~/Code/pco/bin/pco cloud-box allow-my-ip
~/Code/pco/bin/pco cloud-box update-hosts
~/Code/pco/bin/pco cloud-box start
/opt/homebrew/bin/code --folder-uri vscode-remote://ssh-remote+cloud-box/home/ubuntu/Code/$1

