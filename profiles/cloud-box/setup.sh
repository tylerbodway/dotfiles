#!/usr/bin/env bash

TERM=xterm-256color
BLUE=$(tput setaf 4)
NC=$(tput sgr0)

run() {
  local cmd=$1
  echo -e "\n⚡ ${BLUE}${cmd}${NC}"
  eval "${cmd}"
}

# Download latest apt package lists
run 'sudo apt-get update'

# Install Homebrew in non-interactive mode
run 'CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

# Ensure brew command is available
run 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'

# Install Git & ZSH
run 'brew install git zsh'

# Change default shell to ZSH
run 'sudo chsh $(whoami) -s $(which zsh)'

# Clone dotfiles repo
run 'git clone https://github.com/tylerbodway/dotfiles.git $HOME/.dotfiles'
run 'cd $HOME/.dotfiles'
run 'git submodule update --init --recursive'

# Run installation script
run './install cloud-box'
