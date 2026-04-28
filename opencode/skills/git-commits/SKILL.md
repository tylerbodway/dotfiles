---
name: git-commits
description: Compose good git commits and branch histories. Use when staging changes, writing commit messages, splitting work across commits, or planning the commit structure of a branch.
---

# Git Commits

## Principles

- **One commit, one change.** If the subject needs "and," split it.
- **Tests ship with the change.** Behavior and its test coverage belong in
  the same commit. Backfilled or characterization tests are the exception
  and go in their own commit.
- **Refactor, format, and cleanup commits stand alone.** Never mix them with
  behavior changes. Land prep work first, behavior on top.
- **The branch tells a story.** Commits progress in review order: backfill,
  refactors, behavior change, cleanup.

## Commit messages

### Subject

- Imperative mood: Add, Fix, Update, Remove, Rename, Replace, Extract,
  Consolidate, Cleanup, Support, Backfill
- 50 char soft limit, no trailing period, sentence case
- Specific: "Fix group application response form input prefixing," not
  "Fix form bug"

### Body

Include a body when a reviewer would ask "why did you do it this way?"
Skip it for self-explanatory changes.

The body explains why, not what. The diff shows what. Cover the problem that
prompted the change, alternatives considered, constraints that shaped the
approach, and anything the next person touching this code should know.

Wrap at 72 characters.

## Dependencies

When writing the message prose, load `writing-voice`.
