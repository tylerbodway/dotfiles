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

source $DOTFILES/zsh/evals.sh
source $DOTFILES/zsh/aliases.sh