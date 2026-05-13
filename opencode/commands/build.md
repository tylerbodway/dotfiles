---
description: Build a planned change - break the plan into tickets, then work them as commits on the plan's branch
---

Build a planned change. On first run, break the plan into `tk` tickets. On subsequent runs, work the next ready ticket as a commit on the plan's branch.

Input: $ARGUMENTS

---

## Input

Optionally specify a change name (the `.docs/<name>/` folder) or slug. If omitted, infer from conversation context, auto-select if only one active change exists, or prompt the user.

---

## Steps

### 1. Select the change

Resolve the target plan under `.docs/`:

- If a name or slug was passed, use it.
- Otherwise infer from conversation context.
- If exactly one active change exists (`.docs/*/plan.md` or `.docs/*/plan-*.md`, excluding `.docs/archive/`), auto-select.
- Otherwise list candidates via Glob and let the user pick.

Announce: "Building: **\<name>**"

### 2. Read the plan

Locate the plan file:

- Single-plan project: `.docs/<name>/plan.md`.
- Multi-plan project (`.docs/<name>/slices.md` exists): prompt the user to choose among `.docs/<name>/plan-*.md`.

Read the plan. Also read `slices.md`, `research.md`, and `intake.md` if present, for context.

If no plan file exists, stop and suggest `/plan` first.

### 3. Resolve `Branch:` and `Tag:`

Look for these declarations in the plan's header (top section, before the first `##`):

```markdown
Branch: tb/<slug>
Tag: <slug>
```

**If both are present:** use them. By convention they share the slug.

**If missing or partial:** derive the slug from the change name or the plan-`<slug>`.md filename. Default branch is `tb/<slug>`. Tell the user the derived values and offer to add them to the plan header. If they agree, edit the plan to insert the declarations under the title.

The slug must be lowercase, hyphenated, no spaces.

### 4. Decide mode: breakdown or execute

Run:

```
tk query '.[] | select(.tags // [] | index("<slug>"))' 2>/dev/null
```

(Or fall back to `tk ready -T <slug>` plus `tk closed -T <slug>` and check both — `query` requires `jq`, which Tyler has.)

- **No tickets exist for this slug → breakdown mode (Step 5).**
- **Tickets exist → execute mode (Step 6).**

---

### 5. Breakdown mode (first run)

#### 5a. Propose the breakdown

Read the plan. Decompose it into commit-sized tickets. Each ticket is one logical change that leaves the project in a green state.

Apply `git-commits` principles when sizing tickets:

- One ticket, one change. If the title needs "and," split it.
- Tests ship with the behavior change in the same ticket.
- Refactors, formatting, and cleanup get their own tickets, ordered before the behavior change they support.

Identify dependencies. A ticket depends on another only when it cannot start until the other is done. Default to fewer dependencies — let the DAG be wide and shallow.

**Assign trust markers.** Each ticket inherits the plan's trust marker by default, but adjust per-ticket where appropriate:

- A schema migration ticket inside an otherwise `review` slice may bump to `pair`.
- A pure docs/comment ticket inside a `review` slice may drop to `auto`.

Markers are stored as `tk` tags (alongside the slug tag). See **Trust Markers** below.

Present the proposed breakdown:

```
## Proposed tickets for <slug>

1. <Title>  [trust: review]
   - Description: <one sentence>
   - Depends on: <none | ticket numbers from this list>
   - Priority: <0-4, default 2>

2. <Title>  [trust: auto]
   ...
```

Wait for user confirmation. Iterate until the user approves.

#### 5b. Create the tickets

For each approved ticket, in order:

```bash
tk create "<title>" \
  --tags <slug>,trust:<auto|review|pair> \
  --priority <p> \
  --description "<one-line description>"
```

Capture the returned ID. Store the mapping (proposal-number → ticket-ID) for the next step.

#### 5c. Wire dependencies

For each ticket with declared dependencies, run `tk dep <id> <dep-id>`. Resolve proposal-numbers via the mapping captured above.

#### 5d. Append the ticket index to the plan

Edit the plan file. Append (or replace if it exists) a `## Tickets` section at the end:

```markdown
## Tickets

- <id> — <title> _(trust: <marker>)_
- <id> — <title> _(trust: <marker>)_
- ...
```

IDs and titles only. No statuses. This index is static — `tk show` is the source of status truth.

#### 5e. Check out the branch

```bash
git rev-parse --verify tb/<slug> 2>/dev/null
```

- If the branch exists: `git checkout tb/<slug>`.
- If not: `git checkout -b tb/<slug>` from the current branch (usually `main`/`master` — confirm with the user if uncertain).

If the working tree is dirty, stop and surface to the user.

#### 5f. Stop

Tell the user:

- Branch is checked out.
- N tickets created with tag `<slug>`.
- Re-run `/build` to start working tickets.

Do not write code in this run.

---

### 6. Execute mode (subsequent runs)

#### 6a. Verify branch

Check current branch:

```bash
git branch --show-current
```

If not `tb/<slug>`:

- If the branch exists locally, offer to switch.
- If not, surface to the user — something is off.

Do not switch silently.

#### 6b. Find the next ready ticket

```bash
tk ready -T <slug>
```

- Empty output → all tickets done. **If this plan belongs to an initiative** (`Initiative:` declared in the header, or located inside a folder with `slices.md`), update the slice's `Status:` to `complete` in `.docs/<initiative>/slices.md`. Show a summary, then suggest:
  - If other slices in the initiative are still open: "Slice `<slug>` complete. Run `/build <other-slug>` to continue, or open a worktree for parallel work."
  - If every slice is now complete: "All slices complete. Run `/archive <initiative>` to retire the folder."
  - For a standalone plan: "All tickets complete. Run `/archive <slug>`."

  Then stop.

- One result → that's the next ticket.
- Multiple results → take the top one (sorted by priority, then ID). Mention the others briefly.

#### 6c. Load `tk-workflow`

Load the `tk-workflow` skill. It defines the per-ticket loop, including how to honor trust markers and pause behavior between tickets.

#### 6d. On stop conditions

If the per-ticket loop hits a stop condition (verification fails non-trivially, scope grew, plan flaw, seam drift, etc.):

- Add a `tk add-note` describing the situation.
- Leave the ticket `in_progress`.
- Surface to the user with options.

**Special case: seam-change proposal.** If implementation reveals that a seam (declared in the parent `slices.md`) needs to change shape:

```
## Seam-change proposal

Seam: <name>
Current shape: <description>
Proposed shape: <description>
Why: <reasoning>
Affected slices: <slug>, <slug>
Affected consumers: <list>

Options:
1. Revise slices.md and proceed (run `/slice` in update mode)
2. Find a way to fit the existing seam (recommended for small adjustments)
3. Drop this work and flag for a separate slice

What would you like to do?
```

Do not invent fixes outside the ticket's scope. Do not edit the plan or `slices.md` unilaterally.

---

## Trust markers

Markers are stored as `tk` tags (`trust:auto`, `trust:review`, `trust:pair`) alongside the slug tag — `tk` has no separate label concept. They control the agent's per-ticket pause behavior. They do not change what the agent does — only how often it asks before proceeding.

**Auto** is appropriate when:

- The change is mechanical and well-tested (dep bumps, codemods, test additions).
- A failure mode is loud (CI catches it).
- The blast radius is small.

**Review** is the default for most feature work and bug fixes.

**Pair** is appropriate when:

- The change touches a shared seam.
- The change is irreversible (migrations, deletions).
- Security or correctness matters more than speed.
- The agent's confidence is meaningfully below the user's.

When in doubt, use a higher trust level (more pausing). The user can always say "go" if the agent over-asks.

---

## Resumability

Running `/build` again is always safe. It re-reads the plan, re-checks the tag, and either resumes execute mode or (rarely) re-enters breakdown if no tickets exist.

To re-do a breakdown:

1. Close or remove the existing tickets manually (`tk close` each, or `rm .tickets/<id>.md` for a hard reset).
2. Remove the `## Tickets` section from the plan.
3. `/build` will re-enter breakdown mode.

---

## Parallel builds

When the parent `slices.md` shows independent slices, you can build them in parallel:

```bash
git worktree add ../<repo>-<slug> tb/<slug>
```

Open a fresh OpenCode session in the worktree. Run `/build <slug>`. Each session reads its own plan and works its own ticket queue.

`tk` tickets are tagged per slug, so the ready-queue stays slice-scoped. The shared `slices.md` is the seam contract each session must respect.

If a parallel session hits a seam-change proposal, it pauses and surfaces — the other sessions keep going on their own tickets.

---

## Guardrails

- Never write code in breakdown mode.
- Never switch branches silently.
- Never proceed if the working tree is dirty unless the user has acknowledged it.
- Never edit the plan to fix design issues — surface and ask.
- Never edit `slices.md` mid-build — issue a seam-change proposal.
- Never auto-create new tickets mid-execution to handle discovered work — surface and ask.
- One ticket at a time per session. Always serial within a session.
- Honor the trust marker for pause behavior.
