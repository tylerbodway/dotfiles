#!/usr/bin/env zsh

export TERM="xterm-256color"
BLUE="$(tput setaf 4)"
NC="$(tput sgr0)"

run() {
  local cmd=$1
  echo -e "\n⚡ ${BLUE}${cmd}${NC}"
  eval "${cmd}"
}

# Install Xcode Command Line Tools
run 'xcode-select --install'

# Wait until Xcode Command Line Tools is finished installing
until $(xcode-select --print-path &> /dev/null); do
  sleep 5;
done

# Install Homebrew
run "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""

# Ensure brew command is available
run 'eval "$(/opt/homebrew/bin/brew shellenv)"'

# Clone dotfiles repo
run 'git clone https://github.com/tylerbodway/dotfiles.git ~/.dotfiles'
run 'cd ~/.dotfiles'
run 'git remote set-url origin git@github.com:tylerbodway/dotfiles.git'
run 'git submodule update --init --recursive'

# Run installation script
run './install'

