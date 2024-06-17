#!/usr/bin/env zsh

# Install Xcode Command Line Tools
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ensure brew command is available
eval "$(/opt/homebrew/bin/brew shellenv)"

# Clone dotfiles repo
git clone --recurse-submodules git@github.com:tylerbodway/dotfiles ~/.dotfiles

# Run installation script
cd ~/.dotfiles
./install mac
