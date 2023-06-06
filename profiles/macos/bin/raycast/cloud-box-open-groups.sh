#!/usr/bin/env zsh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open groups
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 👨🏻‍💻
# @raycast.packageName Cloud Box

# Documentation:
# @raycast.description Allow current IP, update hosts, and open code editor
# @raycast.author Tyler Bodway
# @raycast.authorURL https://github.com/tylerbodway

~/Code/pco/bin/pco cloud-box allow-my-ip
~/Code/pco/bin/pco cloud-box start
/opt/homebrew/bin/code --folder-uri vscode-remote://ssh-remote+cloud-box/home/ubuntu/Code/groups

