# This env file must live in the home directory in order to set a custom
# config directory. This is the bare minimum to point ZSH to ~/.config/zsh
#
# DO NOT ADD TO THIS FILE.
# See ~/.config/zsh to make configuration changes

export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

source "$ZDOTDIR/.zshenv"
