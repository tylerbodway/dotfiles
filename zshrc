plugins=(git ruby rails)
setopt auto_cd
cdpath=($HOME/Code $HOME/Projects)

export EDITOR="code --wait"
export DOTFILES=$HOME/dotfiles
export ZSH="$HOME/.oh-my-zsh"
export RBENV_ROOT=$HOME/.rbenv
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.rbenv/shims:$PATH
source $DOTFILES/zsh/prompt.sh
source $ZSH/oh-my-zsh.sh

alias ll="ls -la"
alias bay="bundle && yarn"
alias devlog="tail -f log/development.log | bat --paging=never -l log"

# Include profile specific configuration
source $HOME/.zshrc_include

eval "$($HOME/Code/pco/bin/pco init -)"
