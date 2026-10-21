---
name: pr-proposal
description: Propose a GitHub pull request for the current branch by opening the pre-filled "new pull request" page in the browser for the user to review and submit. Use when the user wants to propose, open, draft, prep, or write up a PR.
---

# Propose PR

Turn the current branch into a pre-filled PR form in the browser so the user can review, tweak, and submit it themselves.

Only open the pre-filled form. Don't run `gh pr create` or call any API that creates the PR. The user wants the final say before anything is public.

## Workflow

### 1. Gather branch facts

```bash
git branch --show-current
git remote get-url origin
git symbolic-ref --short refs/remotes/origin/HEAD   # default base, e.g. origin/main
git fetch origin
git rev-parse --verify --quiet origin/<branch>
```

- **Base branch:** use the repo default unless the branch was clearly cut from another feature branch (stacked PR). If `git log <default>..HEAD` includes commits that belong to a different branch, ask which base to use.
- **Pushed?** The compare page only works once the branch exists on the remote. If `origin/<branch>` is missing, or local is ahead of it (`git status -sb`), tell the user and ask them to push (or push for them if they approve). Wait until it's pushed before opening the URL, or the form will show the wrong diff.
- **Nothing to propose?** If there are no commits between base and HEAD, say so and stop.

### 2. Write the title and description

Invoke the `pr-description` skill and follow it to produce the title and body for this branch.

### 3. Build and open the URL

Write the body to a temp file so markdown survives shell quoting, then build the URL with the bundled script (paths are relative to this skill's directory):

```bash
body="$TMPDIR/pr-body.md"   # write the description here with your file-writing tool
scripts/build-url.sh --title "<title>" --body-file "$body" --base <base>
open "<printed url>"
```

The script reads `origin` to find the host and `owner/repo`, defaults `--head` to the current branch, and URL-encodes everything.

If it warns that the URL is too long (about 8KB or more), GitHub may cut off the body. In that case, copy the body to the clipboard (`pbcopy < "$body"`), open the URL built with an empty body, and tell the user to paste it in.

### 4. Hand off

Give the user a short wrap-up:

- The title, and the description in a fenced markdown block so they can read it without switching windows.
- The base branch you used, and anything you weren't sure about (a guessed base, a template section you left out, intent you inferred).

Remind them that nothing has been submitted: they review and create the PR in the browser.
