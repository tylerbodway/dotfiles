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

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(rbenv init - zsh)"
eval "$(fnm env --use-on-cd)"
eval "$($HOME/Code/pco/bin/pco init -)"

alias ll="ls -la"
alias dotedit="code $DOTFILES"
alias zedit="code $DOTFILES/zshrc"
alias devlog="tail -f log/development.log"
alias bay="bundle && yarn"
alias super-tail="grc tail -f $HOME/Code/*/log/development.log"
alias super-tail-groups="grc tail -f $HOME/Code/{api,church-center,groups,people}/log/development.log"
alias dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"small-spacer-tile\";}' && killall Dock"
alias cb-start="pco cloud-box start"
alias cb-stop="pco cloud-box stop"
alias cb-ip="pco cloud-box allow-my-ip"
alias cb-groups="code --folder-uri vscode-remote://ssh-remote+cloud-box/home/ubuntu/Code/groups"
alias cb-work="cb-start && cb-ip && sleep 10 && cb-groups"
alias cb-nuke="pco cloud-box nuke --skip-confirm && pco cloud-box provision --auto"
alias worble="ruby ~/Projects/worble/worble.rb"