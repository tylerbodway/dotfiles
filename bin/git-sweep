#!/usr/bin/env zsh
# git sweep

source "$DOTFILES/zsh/colored-echo.sh"

# Ensure command is run within a git repository
if [ -d .git ]; then

  # Find the default branch name. Could be `master`, `main`, `next`, etc.
  DEFAULT_BRANCH=`git remote show origin | sed -n '/HEAD branch/s/.*: //p'`

  # Ensure we're on default branch.
  git checkout $DEFAULT_BRANCH &> /dev/null

  # Make sure we're working with the most up-to-date version.
  status_echo "Getting up-to-date with origin ..."
  git fetch origin

  # Prune locally tracked branches that have been deleted in remote.
  status_echo "Pruning tracked branches ..."
  git remote prune origin

  # Collect branch names that have been fully merged locally & remotely.
  MERGED_LOCALLY=$(git branch --merged | grep -v $DEFAULT_BRANCH)
  MERGED_REMOTELY=$(git branch -r --merged origin/$DEFAULT_BRANCH | sed 's/ *origin\///' | grep -v "$DEFAULT_BRANCH$")

  # Remove local branches upon confirmation.
  if [ -n "$MERGED_LOCALLY" ]; then
    status_echo "Removing fully merged local branches ..."
    echo "The following local branches will be removed:"
    # formatted_branch_list=$(format_branch_list $MERGED_LOCALLY)
    danger_echo $MERGED_LOCALLY | awk '{$1=$1};1' | sed 's/^/- /'

    if read -q "REPLY?Continue (y/N)? "; then
      git branch --merged | grep -v $DEFAULT_BRANCH \
        | xargs -r git branch -d
      success_echo "\nDone!"
    else
      warning_echo "\nSkipped."
    fi
  fi

  # Remove remote branches upon confirmation.
  if [ -n "$MERGED_REMOTELY" ]; then
    status_echo "Removing fully merged remote branches ..."
    echo "The following remote branches will be removed:"; tput sgr 0
    # formatted_branch_list=$(format_branch_list $MERGED_REMOTELY)
    danger_echo $MERGED_REMOTELY | awk '{$1=$1};1' | sed 's/^/- /'

    if read -q "REPLY?Continue (y/N)? "; then
      git branch -r --merged origin/$DEFAULT_BRANCH | sed 's/ *origin\///' \
        | grep -v "$DEFAULT_BRANCH$" | xargs -I% git push origin :% 2>&1 \
        | grep --colour=never 'deleted'
      success_echo "\nDone!"
    else
      warning_echo "\nSkipped."
    fi
  fi

else
  warning_echo "You must be in a git repository to 🧹 it."
fi;
