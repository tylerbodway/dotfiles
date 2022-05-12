export EDITOR="code --wait"
export DOTFILES=$HOME/dotfiles
export ZSH="$HOME/.oh-my-zsh"
export RBENV_ROOT=$HOME/.rbenv
export GPG_TTY=$(tty)

export PATH=$HOME/bin:$PATH
export PATH="./bin:$PATH"

# Prompt
ZSH_THEME="spaceship"
# https://spaceship-prompt.sh/options/
SPACESHIP_CHAR_SYMBOL="$ "
SPACESHIP_GIT_BRANCH_COLOR="yellow"
SPACESHIP_GIT_STATUS_PREFIX=" {"
SPACESHIP_GIT_STATUS_SUFFIX="}"
SPACESHIP_RUBY_SYMBOL="▼ "
SPACESHIP_BATTERY_SYMBOL_FULL="🔋 "
SPACESHIP_HOST_PREFIX="at 📦 "
SPACESHIP_PROMPT_ORDER=(
  dir
  host
  git
  node
  ruby
  xcode
  php
  aws
  exec_time
  line_sep
  battery
  exit_code
  char
)

plugins=(git ruby rails)

setopt auto_cd
cdpath=($HOME/Code $HOME/Projects)

source $ZSH/oh-my-zsh.sh

case "$OSTYPE" in
  darwin*)
    eval "$(/opt/homebrew/bin/brew shellenv)"
  ;;
  linux*)
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  ;;
esac

eval "$(fnm env --use-on-cd)"
eval "$(rbenv init - zsh)"
eval "$($HOME/Code/pco/bin/pco init -)"

case "$OSTYPE" in
  darwin*)
    alias dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"small-spacer-tile\";}' && killall Dock"
    alias dotedit="code $DOTFILES"
    alias zedit="code $DOTFILES/zshrc"
    alias ssh-clear-hosts="rm ~/.ssh/known_hosts ~/.ssh/known_hosts.old"
    alias worble="ruby ~/Projects/worble/worble.rb"

    alias cb-start="pco cloud-box start"
    alias cb-stop="pco cloud-box stop"
    alias cb-ip="pco cloud-box allow-my-ip"
    alias cb-groups="code --folder-uri vscode-remote://ssh-remote+cloud-box/home/ubuntu/Code/groups"
    alias cb-work="cb-start && cb-ip && sleep 10 && cb-groups"
    alias cb-nuke="pco cloud-box nuke --skip-confirm"
    alias cb-prov="pco cloud-box provision --auto --fast"
    alias cb-new="cb-nuke && cb-prov && ssh-clear-hosts"
  ;;
esac

alias ll="ls -la"
alias bay="bundle && yarn"
alias devlog="tail -f log/development.log"
alias super-tail="grc tail -f $HOME/Code/*/log/development.log"
alias super-tail-groups="grc tail -f $HOME/Code/{api,church-center,groups,people}/log/development.log"
