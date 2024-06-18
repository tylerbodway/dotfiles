#!/usr/bin/env bash

set -x # print commands being run

# Download latest apt package lists
sudo apt-get update

# Install Homebrew in non-interactive mode
CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null

# Ensure brew command is available
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install Git & ZSH
brew install git zsh

# Change default shell to ZSH
sudo chsh $(whoami) -s $(which zsh)

# Clone dotfiles repo
git clone https://github.com/tylerbodway/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
git submodule update --init --recursive

# Run installation script
./install cloud-box
