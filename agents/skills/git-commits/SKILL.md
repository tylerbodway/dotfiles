---
name: git-commits
description: Compose good git commits and branch histories. Use when committing, staging changes, writing commit messages, splitting work across commits, cleaning up or reordering a branch's history, or creating a new branch.
---

# Git Commits

Commits are how reviewers read a branch and how future maintainers learn why changes were made. Optimize for them, not for the speed of committing.

## Principles

- **One commit, one change.** If the subject needs "and," split it.
- **Tests ship with the change.** Behavior and its test coverage belong in
  the same commit. Backfilled or characterization tests are the exception
  and go in their own commit.
- **Refactor, format, and cleanup commits stand alone.** Never mix them with
  behavior changes. Land prep work first, behavior on top. A reviewer can
  skim a pure refactor, but a refactor hiding a behavior change forces them
  to scrutinize every line.
- **The branch tells a story.** Commits progress in review order: backfill,
  refactors, behavior change, cleanup.
- **Every commit should pass.** Each one should build and pass tests on its
  own, so the history stays bisectable and revertable.

## Branch name

When creating a new branch, always use the format: `tb/<slug>[/issue-ID]`
Examples: `tb/add-feature` or `tb/fix-bug/eng-123`

The issue ID in the branch name is what links the work to the tracker, so
there's no need to repeat it in commit messages.

## Workflow

1. **Survey the changes.** Run `git status` and `git diff` (plus
   `git diff --staged` if anything is already staged). Read what actually
   changed, not just the file names.
2. **Plan the commits.** Group hunks by the principles above and order them
   in review order. Unrelated changes (a stray fix, a formatting pass) get
   their own commit or get left out.
3. **Check in when it matters.** If the plan is a single obvious commit,
   just commit. If it spans multiple commits and the user is in the loop,
   show the plan (subjects plus which changes go where) and wait for a go
   ahead. If the user isn't available, such as in an unattended or
   background run, commit following the plan.
4. **Verify, then commit each slice.** Stage one slice, run the relevant
   tests and linters, then commit. Repeat.

## Pre-commit

Always run appropriate testing and linting commands on the changes before committing using project guidelines.

If a pre-commit hook fails, fix the cause and make a new commit attempt.
Don't bypass hooks with `--no-verify`.

## Staging

Interactive commands (`git add -p`, `git add -i`, `git rebase -i` without a
sequence editor) wait on a terminal you can't drive, so use non-interactive
equivalents:

- Whole files: `git add <path>`
- Part of a file: write a patch containing only the wanted hunks and stage
  it with `git apply --cached <patch>`. Check the result with
  `git diff --staged` before committing.
- If one hunk mixes two concerns, temporarily edit the file down to the
  first concern, stage and commit it, then restore the rest.

## Commit messages

### Subject

- Imperative mood: Add, Fix, Update, Remove, Rename, Replace, Extract,
  Consolidate, Cleanup, Support, Backfill
- Keep to ~50 character limit, no trailing period, sentence case
- Specific: "Fix group application response form input prefixing," not
  "Fix form bug"
- Match the repo's existing conventions (check `git log --oneline`) if
  they differ, e.g. conventional-commit prefixes.

### Body

Include a body when a reviewer would ask "why did you do it this way?"
Skip it for self-explanatory changes.

The body explains why, not what. The diff shows what. Cover the problem that
prompted the change, alternatives considered, constraints that shaped the
approach, and anything the next person touching this code should know.

Wrap at 72 characters.

Write multi-line messages to a temp file and use `git commit -F <file>`, so
wrapping and blank lines come out exactly as written.

Don't reference issue IDs or links. If talking about work that will be done,
say that simply. Git commits should stand alone regardless of the issue
tracker we're currently using.

Don't add AI attribution trailers such as `Co-authored-by` or "Generated
with". The commits are the user's.

## Reshaping history

Cleaning up a branch is part of making it tell a story. Rewriting local,
unpushed commits is fine. Once a commit has been pushed, others may have
built on it, so ask before rewriting it. To check, see what's unpushed with
`git log @{u}..` (if there's no upstream, the branch hasn't been pushed).

- **Amend a past commit:** stage the fix, then
  `git commit --fixup=<sha>` and fold it in with
  `GIT_SEQUENCE_EDITOR=: GIT_EDITOR=true git rebase -i --autosquash <base>`.
  Setting both editors keeps git from stopping to wait for one.
- **Reword a past commit:** `--fixup=reword:` insists on an editor and
  rejects `-m`, so write the `amend!` commit by hand. Put
  `amend! <original subject>`, a blank line, then the full new message in
  a file, commit it with `git commit --allow-empty -F <file>`, and
  autosquash as above.
- **Reorder or drop commits:** write the todo list you want and use it as
  the sequence editor, e.g.
  `GIT_SEQUENCE_EDITOR="cp /path/to/todo" git rebase -i <base>`.
- **Split a commit:** check it out in a rebase (`edit` in the todo list),
  `git reset HEAD~`, then re-stage and commit it in slices before
  `git rebase --continue`.

After any rewrite, compare `git diff <old-head> HEAD`: it should be empty
unless you meant to change content. Use `git reflog` to recover if a rebase
goes wrong.
