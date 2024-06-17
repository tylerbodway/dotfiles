#!/usr/bin/env bash

set -x # print commands being run

# Download latest apt package lists
sudo apt-get update

# Install system requirements for Homebrew
sudo apt-get install build-essential

# Install Homebrew
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Ensure brew command is available
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install ZSH
sudo apt install -y zsh

# Change default shell to ZSH
sudo chsh $(whoami) -s /usr/bin/zsh

# Clone dotfiles repo
git clone --recurse-submodules git@github.com:tylerbodway/dotfiles $HOME/.dotfiles

# Run installation script
cd $HOME/.dotfiles
./install cloud-box
