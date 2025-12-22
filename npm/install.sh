#!/usr/bin/env zsh

yq eval '.packages[]' npm/install.yaml | while read -r package; do
  if npm list -g --depth=0 "$package" &>/dev/null; then
    if npm outdated -g "$package" 2>/dev/null | grep -q "$package"; then
      echo "Upgrading $package"
      npm install -g "$package@latest" >/dev/null
    else
      echo "Using $package"
    fi
  else
    echo "Installing $package"
    npm install -g "$package@latest" >/dev/null
  fi
done
