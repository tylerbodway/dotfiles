#!/usr/bin/env bash
#
# Build a GitHub compare URL that pre-fills a pull request title and body.
#
# Usage:
#   build-url.sh --title "Add thing" --body-file /path/to/body.md [--base main] [--head branch] [--remote origin]
#
# The body is read from a file (or stdin with `--body-file -`) so markdown with
# backticks, quotes, and newlines never has to survive shell quoting.
#
# Prints the URL to stdout. Warns on stderr when the URL is long enough that
# GitHub or the browser may truncate it.

set -euo pipefail

# GitHub starts rejecting or truncating compare URLs somewhere around 8KB.
url_length_warning=8000

usage() {
  sed -n '3,6p' "$0" | sed 's/^# \{0,1\}//' >&2
  exit 1
}

title="" body_file="" base="" head="" remote="origin"

while [ $# -gt 0 ]; do
  case "$1" in
    --title) title="$2"; shift 2 ;;
    --body-file) body_file="$2"; shift 2 ;;
    --base) base="$2"; shift 2 ;;
    --head) head="$2"; shift 2 ;;
    --remote) remote="$2"; shift 2 ;;
    -h | --help) usage ;;
    *) echo "Unknown argument: $1" >&2; usage ;;
  esac
done

[ -n "$title" ] && [ -n "$body_file" ] || usage

# Percent-encode every byte except unreserved characters (RFC 3986).
urlencode() {
  local LC_ALL=C string="$1" i c
  for ((i = 0; i < ${#string}; i++)); do
    c="${string:i:1}"
    case "$c" in
      [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
      *) printf '%%%02X' "'$c" ;;
    esac
  done
}

if [ "$body_file" = "-" ]; then
  body="$(cat)"
else
  body="$(cat "$body_file")"
fi

remote_url="$(git remote get-url "$remote")"
remote_url="${remote_url%/}"
remote_url="${remote_url%.git}"

# Handles https://host/owner/repo, ssh://git@host:port/owner/repo, and git@host:owner/repo
if [[ "$remote_url" =~ ^[a-z]+://([^@/]+@)?([^/:]+)(:[0-9]+)?/(.+)$ ]]; then
  host="${BASH_REMATCH[2]}"
  repo="${BASH_REMATCH[4]}"
elif [[ "$remote_url" =~ ^([^@]+@)?([^:]+):(.+)$ ]]; then
  host="${BASH_REMATCH[2]}"
  repo="${BASH_REMATCH[3]}"
else
  echo "Could not parse git remote URL: $remote_url" >&2
  exit 1
fi
host="${host#ssh.}"

if [ -z "$base" ]; then
  base="$(git symbolic-ref --short "refs/remotes/$remote/HEAD" 2>/dev/null || echo "$remote/main")"
  base="${base#"$remote"/}"
fi

if [ -z "$head" ]; then
  head="$(git branch --show-current)"
  [ -n "$head" ] || { echo "Not on a branch (detached HEAD). Pass --head explicitly." >&2; exit 1; }
fi

url="https://${host}/${repo}/compare/${base}...${head}?expand=1&title=$(urlencode "$title")&body=$(urlencode "$body")"

if [ "${#url}" -gt "$url_length_warning" ]; then
  echo "warning: URL is ${#url} characters; GitHub may truncate or reject it." >&2
fi

echo "$url"
