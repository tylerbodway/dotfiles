# Exports
export EDITOR="code --wait"
export DOTFILES=$HOME/dotfiles
export RBENV_ROOT=$HOME/.rbenv
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY=1

# PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH
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
  time           # Time stamps section
  user           # Username section
  dir            # Current directory section
  host           # Hostname section
  git            # Git section (git_branch + git_status)
  # hg           # Mercurial section (hg_branch  + hg_status)
  # package      # Package version
  node           # Node.js section
  ruby           # Ruby section
  # elixir       # Elixir section
  xcode          # Xcode section
  # swift        # Swift section
  # golang       # Go section
  php            # PHP section
  # rust         # Rust section
  # haskell      # Haskell Stack section
  # julia        # Julia section
  # docker       # Docker section
  aws            # Amazon Web Services section
  # venv         # virtualenv section
  # conda        # conda virtualenv section
  # pyenv        # Pyenv section
  # dotnet       # .NET section
  # ember        # Ember.js section
  # kubecontext  # Kubectl context section
  # terraform    # Terraform workspace section
  exec_time      # Execution time
  line_sep       # Line break
  battery        # Battery level and status
  vi_mode        # Vi-mode indicator
  jobs           # Background jobs indicator
  exit_code      # Exit code section
  char           # Prompt character
)

# Aliases
alias ll="ls -la"
alias zedit="code $DOTFILES/zshrc"
alias devlog="tail -f log/development.log"
alias bay="bundle && yarn"
alias super-tail="grc tail -f ~/Code/*/log/development.log"
alias super-tail-groups="grc tail -f ~/Code/{api,church-center,groups,people}/log/development.log"
alias dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"small-spacer-tile\";}' && killall Dock"
alias cb-start="pco cloud-box start"
alias cb-stop="pco cloud-box stop"
alias cb-ip="pco cloud-box allow-my-ip"

# cd into these directories from anywhere
setopt auto_cd
cdpath=($HOME/Code $HOME/Projects)

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$($HOME/Code/pco/bin/pco init -)"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# GPG Keys
export GPG_TTY=$(tty)
case "$OSTYPE" in
  darwin*) gpg-agent --daemon --use-standard-socket &>/dev/null ;;
esac