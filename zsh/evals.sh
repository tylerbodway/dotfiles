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