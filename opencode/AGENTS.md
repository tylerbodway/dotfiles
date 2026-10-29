# Global guidelines

## Code comments

- A comment explains only what the code, a test name, and git history
  can't already say to someone reading right now. Default: no comment.
- Never duplicate the code or restate what a well-named test
  communicates. Don't comment to excuse unclear code — fix the naming
  or structure.
- Whatever reasoning a comment records, also put it in the commit
  message. Comments serve immediate understanding; commit messages
  satisfy deeper curiosity. A "why" must not exist only in one place.

## Git

- Branches: `tb/<slug>/<issue-ID>` when an issue applies.
- Use the `git-commits` skill when committing. One commit per change;
  refactor/format/cleanup commits never mix with behavior changes.
- When direction changes mid-session: on un-pushed branches, fold
  amended work back into its existing commit(s) to keep history clean.
  Once commits exist on origin, default to new commits instead of
  rewriting history.
- Commit messages: imperative subject, why-oriented body. Reasoning
  and alternatives belong in the message, not held only in code.

## Contributions & discussions

- Never post or submit to GitHub, Slack, or Linear (replies, comments,
  PR submits). Produce final drafts; I post them myself.
- PRs: propose them, don't open/merge them.
- For anything I'll send to teammates: warm, casual, brief, no
  AI-voice filler. Don't get bogged down in specifics.

## Code approach

- Minimal change wins. Inline today; extract an abstraction only when
  a second real consumer exists.
- No new tests for pure refactors; test external behavior only.
- Stay inside the stated scope, repo, and branch. Don't read or pull
  unrelated branches unless I ask.
- Don't engineer around domain edge cases I've declared impossible or
  out of scope — trust the stated behavior.
- Independent units of work: run them in parallel via subagents.

## Reviews & verification

- Treat incoming review feedback as unverified: confirm against the
  code, give a verdict, no code changes until we've discussed.
- Screenshots and visual verification artifacts go in `~/Downloads`.
- Planning/research requests are discussion only: analyze, present
  options and tradeoffs, never implement or open artifacts unprompted.
