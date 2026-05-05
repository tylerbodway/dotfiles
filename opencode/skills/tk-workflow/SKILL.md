---
name: tk-workflow
description: Execute tickets from the `tk` queue as commits on a plan branch. Use when working through a plan that has been broken down into tickets, or when an agent needs to pick up the next ready ticket and turn it into a verified commit.
---

# tk Workflow

Execute one ticket at a time from a plan's `tk` queue. Each ticket becomes one commit on the plan's branch. Pause behavior between tickets is controlled by the ticket's trust marker.

## Vocabulary

- **Plan**: a markdown file (`plan.md` or `plan-<slug>.md`) declaring `Branch: tb/<slug>`, `Tag: <slug>`, and `Trust: <auto|review|pair>` in its header.
- **Slug**: the shared identifier for a plan's branch and ticket tag. Lowercase, hyphenated.
- **Ticket**: a `tk` ticket tagged with the plan's slug. Represents one commit-sized change.
- **Ready**: a ticket with status `open` or `in_progress` whose dependencies are all `closed`.
- **Trust marker**: `tk` tag of `trust:auto`, `trust:review`, or `trust:pair` controlling pause behavior. Stored via `--tags` — `tk` has no `--label` flag.

## Command surface

Only these `tk` commands are needed:

| Command                                                                                    | Purpose                               |
| ------------------------------------------------------------------------------------------ | ------------------------------------- |
| `tk create "<title>" --tags <slug>,trust:<marker> --priority <0-4> --description "<text>"` | Create a ticket                       |
| `tk dep <id> <dep-id>`                                                                     | Add dependency (id depends on dep-id) |
| `tk ready -T <slug>`                                                                       | List unblocked tickets for a plan     |
| `tk show <id>`                                                                             | Read a ticket                         |
| `tk start <id>`                                                                            | Mark in_progress                      |
| `tk add-note <id>` (or pipe stdin)                                                         | Append a timestamped working note     |
| `tk close <id>`                                                                            | Mark closed                           |

Partial IDs work (`tk show a3f` matches `ar-a3f2`).

## Per-ticket loop

For each ticket, in order:

1. **Verify branch.** Current branch must be `tb/<slug>`. If not, stop and surface to the user.
2. **`tk start <id>`**.
3. **Read the ticket** with `tk show <id>`. Note the trust marker (`trust:auto|review|pair` tag). Read the relevant section of the plan for design context.
4. **Make the change.** Stay within the ticket's scope. The plan is the design source of truth — do not invent new design decisions.
   - **For `trust:pair` tickets**, surface material decisions before acting (e.g., "About to drop column `users.legacy_token`. Confirm?"). Brief diffs of intended changes are fine.
   - **For `trust:review` and `trust:auto`**, proceed without per-step approval but stay within scope.
5. **Verify.** Run the project's tests, build, and lint per repo conventions. Fix in place if they fail.
6. **Commit.** Subject format: `<change>`. Example: `Extract TokenRefresher service`.
   - Imperative mood, sentence case, no trailing period.
   - No ticket numbers or IDs in the subject line.
   - Body when a reviewer would ask "why this way?" — see `git-commits` skill.
7. **`tk add-note <id>`** with a one-line summary and the commit SHA. Pipe via stdin:
   ```
   git rev-parse --short HEAD | xargs -I{} echo "Done: <summary> ({})" | tk add-note <id>
   ```
8. **`tk close <id>`**.
9. **Pause based on trust marker** (see below).

## Pause behavior

After closing a ticket, behavior depends on its trust marker:

- **`trust:auto`** — show a one-line close summary (`Closed: <id> — <subject> (<sha>)`), then automatically continue to the next ready ticket. The user can interrupt.
- **`trust:review`** (default) — show the close summary and the next ready ticket, then pause for explicit "continue" confirmation.
- **`trust:pair`** — show the close summary plus a brief diff stat, then pause for explicit approval before proceeding.

If a ticket has no trust marker, treat it as `trust:review`.

## Selecting the next ticket

Run `tk ready -T <slug>`. The output is sorted by priority then ID. Pick the top one. If the user has indicated a preference, honor it.

When `tk ready -T <slug>` returns nothing, the plan is done. Suggest `/archive`.

## Failure modes

Stop and surface to the user — do not work around — when:

- **Verification fails and the fix isn't obvious.** Add a note describing what you tried, leave the ticket `in_progress`.
- **The ticket's scope grew.** Don't split it yourself. Add a note, surface to user.
- **A new dependency surfaces.** Don't create new tickets unilaterally. Add a note, surface to user.
- **The plan is wrong.** Don't edit the plan. Add a note, surface to user. They'll decide whether to update `plan.md` and re-break-down.
- **A seam needs to change** (defined in parent `slices.md`). Surface a seam-change proposal — see `/build` for the template. Don't edit `slices.md` unilaterally.
- **You're not on `tb/<slug>`.** Don't switch silently. Ask.

## Working notes

Use `tk add-note` liberally for anything a future agent (or you, in a fresh session) would want to know:

- What was tried and discarded.
- Surprises in the codebase.
- Commit SHAs.
- Why a verification step was skipped or modified.
- Trust-marker overrides ("Treated this as pair despite the auto tag because the test surface was thin").

Notes accumulate at the bottom of the ticket and are timestamped automatically.

## Dependencies

Load `git-commits` when composing the commit message.
