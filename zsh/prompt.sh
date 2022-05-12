# https://spaceship-prompt.sh/options/

ZSH_THEME="spaceship"
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