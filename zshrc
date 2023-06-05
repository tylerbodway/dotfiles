export ZSH="$HOME/.oh-my-zsh"
export DOTFILES=$HOME/dotfiles
export EDITOR="code --wait"

setopt auto_cd
cdpath=($HOME/Code $HOME/Projects)
plugins=(git ruby rails)

source $DOTFILES/zsh/prompt.sh
source $ZSH/oh-my-zsh.sh

export PATH=$HOME/bin:$PATH
export PATH=$HOME/.rbenv/shims:$PATH

alias ll="ls -la"
alias bay="bundle && yarn"
alias devlog="tail -f log/development.log | bat --paging=never -l log"

eval "$($HOME/Code/pco/bin/pco init -)"

# Include profile specific configuration
source $HOME/.zshrc_include

