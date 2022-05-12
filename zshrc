plugins=(git ruby rails)
setopt auto_cd
cdpath=($HOME/Code $HOME/Projects)

export EDITOR="code --wait"
export DOTFILES=$HOME/dotfiles
export ZSH="$HOME/.oh-my-zsh"
export RBENV_ROOT=$HOME/.rbenv
export GPG_TTY=$(tty)
export PATH=$HOME/bin:$PATH
source $DOTFILES/zsh/prompt.sh
source $ZSH/oh-my-zsh.sh

alias ll="ls -la"
alias bay="bundle && yarn"
alias devlog="tail -f log/development.log"

case "$OSTYPE" in
  darwin*) source $DOTFILES/zsh/macos.sh ;;
  linux*)  source $DOTFILES/zsh/linux.sh ;;
esac

eval "$(fnm env --use-on-cd)"
eval "$($HOME/Code/pco/bin/pco init -)"
