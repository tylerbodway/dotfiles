#!/bin/bash
#
# Build a GitHub PR URL with pre-filled title and body
#
# Usage: build-pr-url.sh <owner> <repo> <base> <head> <title> <body>
#
# Arguments:
#   owner - GitHub repository owner (e.g., "planningcenter")
#   repo  - GitHub repository name (e.g., "groups")
#   base  - Base branch (e.g., "main")
#   head  - Head branch (e.g., "feature-branch")
#   title - PR title
#   body  - PR body (markdown)
#
# Output: The full GitHub PR URL with encoded parameters

set -e

if [ $# -lt 6 ]; then
  echo "Usage: $0 <owner> <repo> <base> <head> <title> <body>" >&2
  exit 1
fi

owner="$1"
repo="$2"
base="$3"
head="$4"
title="$5"
body="$6"

# URL-encode a string using only POSIX tools (xxd + sed)
# Encodes all characters except alphanumerics and -_.~
urlencode() {
  local LC_ALL=C
  local string="$1"
  local length="${#string}"
  local i=0
  local c

  while [ "$i" -lt "$length" ]; do
    c="${string:i:1}"
    case "$c" in
      [a-zA-Z0-9.~_-])
        printf '%s' "$c"
        ;;
      *)
        printf '%s' "$c" | xxd -p -c1 | while read -r hex; do
          printf '%%%s' "$hex" | tr '[:lower:]' '[:upper:]'
        done
        ;;
    esac
    i=$((i + 1))
  done
}

encoded_title=$(urlencode "$title")
encoded_body=$(urlencode "$body")

echo "https://github.com/${owner}/${repo}/compare/${base}...${head}?expand=1&title=${encoded_title}&body=${encoded_body}"
