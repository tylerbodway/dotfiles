#!/bin/bash -l

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Cloud Box
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 📦
# @raycast.packageName Cloud Box

# Documentation:
# @raycast.description start, allow-my-ip, update-hosts, ssh
# @raycast.author Tyler Bodway
# @raycast.authorURL https://github.com/tylerbodway

eval "$($HOME/Code/pco/bin/pco init -)"

pco cloud-box up
