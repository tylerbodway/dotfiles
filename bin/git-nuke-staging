#!/usr/bin/env zsh
# git nuke-staging

source "$DOTFILES/zsh/colored-echo.sh"

echo ""
read "prompt?⚠️  Are you sure you'd like to push a fresh staging? [Y/n]: "
echo ""

if [[ "$prompt" =~ ^[Yy]$ ]]; then
  # Assumes clean working tree
  git checkout master

  # Delete local staging branch
  git branch -D staging

  # Delete origin staging branch
  git push origin :staging

  # Copy new local staging branch from master
  git checkout -b staging master

  # Push fresh staging to origin
  git push --set-upstream origin staging

  success_echo "💥  Staging has been nuked"
else
  status_echo "👎  Nuke canceled"
fi