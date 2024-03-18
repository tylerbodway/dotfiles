#!/bin/bash -l

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Update IP for Cloud Box
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 📦
# @raycast.packageName Cloud Box

# Documentation:
# @raycast.description allow connections from your current IP address
# @raycast.author Tyler Bodway
# @raycast.authorURL https://github.com/tylerbodway

eval "$($HOME/Code/pco/bin/pco init -)"

pco cloud-box allow-my-ip
