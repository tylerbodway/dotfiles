#!/usr/bin/env zsh

yq eval '.gems[]' gem/install.yaml | while read -r gem; do
  if gem list -i "^${gem}$" &>/dev/null; then
    if gem outdated "$gem" | grep -q "$gem"; then
      echo "Upgrading $gem"
      gem update "$gem" >/dev/null
    else
      echo "Using $gem"
    fi
  else
    echo "Installing $gem"
    gem install "$gem" >/dev/null
  fi
done
