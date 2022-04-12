#!/usr/bin/env bash

echo "Downloading latest APT package lists"
sudo apt-get update

echo "Installing zsh"
sudo apt install -y zsh
sudo chsh $(whoami) -s /usr/bin/zsh

echo "Configuring bash"
echo "export EDITOR=\"code --wait\"" >> ~/.bashrc
echo "alias rr=\"bin/rails routes\"" >> ~/.bashrc
echo "alias rc=\"bin/rails console\"" >> ~/.bashrc
echo "alias rdm=\"bin/rails db:migrate\"" >> ~/.bashrc
echo "alias bay=\"bundle && yarn\"" >> ~/.bashrc
echo "alias devlog=\"tail -f log/development.log\"" >> ~/.bashrc

echo "Configuring git"
wget "https://raw.githubusercontent.com/tylerbodway/dotfiles/main/gitconfig" -L -O "$HOME/.gitconfig"
wget "https://raw.githubusercontent.com/tylerbodway/dotfiles/main/gitconfig_company" -L -O "$HOME/Code/.gitconfig_company"

# echo "Cloning extra repos"
# cd ~
# git clone git@github.com:ministrycentered/pco-api.git
# git clone git@github.com:ministrycentered/pco-message-bus.git
