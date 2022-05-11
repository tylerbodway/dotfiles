#!/usr/bin/env bash

printf "\n==== Downloading latest apt package lists ====\n\n"

sudo apt-get update

printf "\n🌷 The package lists are certified fresh!\n"

printf "\n==== Installing homebrew ====\n\n"

# install system requirements for homebrew
sudo apt-get install build-essential
# install via instructions: https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

printf "\n🍺 You can brew now bro!\n"

printf "\n==== Installing zsh ====\n\n"

# install zsh as apt package
sudo apt install -y zsh
# change default shell from bash to zsh
sudo chsh $(whoami) -s /usr/bin/zsh

printf "\n🐚 Ah swell, now you got that z shell!\n"

printf "\n==== Installing oh-my-zsh framework ====\n\n"

# install via instructions: https://ohmyz.sh/#install
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

printf "\n😎 My oh-my, these tools are fly!\n"

printf "\n==== Installing spaceship prompt ====\n\n"

# clone zsh theme into custom folder
git clone git@github.com:spaceship-prompt/spaceship-prompt ~/.oh-my-zsh/custom/themes/spaceship-prompt --depth=1
# symlink .zsh-theme from cloned repository
ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme

printf "\n🚀 T-minus 0 seconds to a great prompt!\n"

printf "\n==== Installing dotfiles ====\n\n"

# clone dotfiles and enter directory
git clone git@github.com:tylerbodway/dotfiles ~/dotfiles && cd ~/dotfiles
# ensure newly installed brew command is available
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# run installation script in dotfiles
./install linux

printf "\n🖋  Crossed your T's and dotted your files!\n"

printf "\n✅ post-provision is complete."
