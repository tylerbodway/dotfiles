case "$OSTYPE" in
  darwin*)
    alias dock-spacer="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"small-spacer-tile\";}' && killall Dock"
    alias dotedit="code $DOTFILES"
    alias zedit="code $DOTFILES/zshrc"
    alias worble="ruby ~/Projects/worble/worble.rb"

    alias cb-start="pco cloud-box start"
    alias cb-stop="pco cloud-box stop"
    alias cb-ip="pco cloud-box allow-my-ip"
    alias cb-groups="code --folder-uri vscode-remote://ssh-remote+cloud-box/home/ubuntu/Code/groups"
    alias cb-work="cb-start && cb-ip && sleep 10 && cb-groups"
    alias cb-nuke="pco cloud-box nuke --skip-confirm && pco cloud-box provision --auto && rm ~/.ssh/known_hosts ~/.ssh/known_hosts.old"
  ;;
esac

alias ll="ls -la"
alias bay="bundle && yarn"
alias devlog="tail -f log/development.log"
alias super-tail="grc tail -f $HOME/Code/*/log/development.log"
alias super-tail-groups="grc tail -f $HOME/Code/{api,church-center,groups,people}/log/development.log"
