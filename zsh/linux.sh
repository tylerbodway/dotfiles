alias super-tail="grc tail -f $HOME/Code/*/log/development.log"
alias super-tail-groups="grc tail -f $HOME/Code/{api,church-center,groups,people}/log/development.log"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source $HOME/pco-box/env.sh
