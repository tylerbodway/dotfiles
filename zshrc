export EDITOR="code --wait"
export DOTFILES=$HOME/dotfiles
export RBENV_ROOT=$HOME/.rbenv
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY=1
export GPG_TTY=$(tty)

export PATH=$PATH:$HOME/bin

# Prompt
fpath=( "$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath )
autoload -U promptinit; promptinit
prompt spaceship
# https://spaceship-prompt.sh/options/
SPACESHIP_USER_COLOR="blue"
SPACESHIP_CHAR_SYMBOL="$ "
SPACESHIP_GIT_BRANCH_COLOR="yellow"
SPACESHIP_GIT_STATUS_PREFIX=" {"
SPACESHIP_GIT_STATUS_SUFFIX="}"
SPACESHIP_RUBY_SYMBOL="▼ "
SPACESHIP_BATTERY_SYMBOL_FULL="🔋 "
SPACESHIP_PROMPT_ORDER=(
  time
  user
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

setopt auto_cd
cdpath=($HOME/Code $HOME/Projects)

eval "$(rbenv init - zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$($HOME/Code/pco/bin/pco init -)"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

alias ll="ls -la"
alias zedit="code $DOTFILES/zshrc"
alias devlog="tail -f log/development.log"
alias bay="bundle && yarn"
alias super-tail="grc tail -f $HOME/Code/*/log/development.log"
alias super-tail-groups="grc tail -f $HOME/Code/{api,church-center,groups,people}/log/development.log"
alias dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"small-spacer-tile\";}' && killall Dock"
alias cb-start="pco cloud-box start"
alias cb-stop="pco cloud-box stop"
alias cb-ip="pco cloud-box allow-my-ip"
alias cb-code="code --folder-uri vscode-remote://ssh-remote+cloud-box/home/ubuntu/Code/groups"
alias cb-work="cb-start && cb-ip && cb-code"