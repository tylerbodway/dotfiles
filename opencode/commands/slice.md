---
description: Slice an initiative - break a multi-PR effort into ordered, seam-aware vertical slices that can each be planned and built independently
---

Slice an initiative too large for a single `/plan`. Produce `slices.md` — an ordered (and where possible, parallelizable) list of vertical slices with seam agreements and dependencies between them.

A slice is a shippable, PR-sized vertical increment. Each slice in `slices.md` becomes its own `plan-<slug>.md` (planned individually via `/plan`), its own branch, and its own PR. Slices that are independent can be built in parallel — possibly in separate worktrees with separate agent sessions.

Vocabulary lives next to your **seam-up** philosophy: a slice ships value end-to-end, and a seam is the contract two slices share.

Input: $ARGUMENTS

---

## Input

The user provides a name (kebab-case) or a description of the initiative. If neither, ask.

They may also reference:

- An `intake.md` from `/intake`
- A `thoughts.md` from `/think`
- A `research.md` from `/research`
- A spec (Linear, Notion, etc.)
- An existing `slices.md` to update

---

## Steps

### 1. Understand the initiative

If unclear, ask:

> "What initiative are we slicing? Describe the end-to-end goal — what shippable value spans multiple PRs."

Derive a kebab-case name. This becomes `.docs/<name>/`.

Read referenced artifacts (`intake.md`, `thoughts.md`, `research.md`, the spec).

### 2. Check for existing context

Use Glob:

- `.docs/<name>/slices.md` — does this initiative already have slices?
- `.docs/<name>/plan-*.md` — partially-planned slices?
- `.docs/<name>/intake.md`, `thoughts.md`, `research.md` — prior work?

If `slices.md` exists, switch to **update mode** (see below).

### 3. Research the landscape

Investigate broadly using the `explore` subagent. Wider sweep than a single-slice `/research` — you're mapping the whole territory.

Look for:

- Major components and seams involved
- Existing patterns to follow or replace
- Coordination points with other teams or systems
- Constraints that shape sequencing
- Where parallel work is genuinely possible vs. forced sequencing

### 4. Identify the slices

Decompose the initiative into ordered, focused slices. Each slice should:

- Be sized for a single `/plan` and a single PR
- Leave the system in a working state when it lands (green at every commit)
- Ship a vertical increment of value where possible (front-to-back, not layer-by-layer)
- Have clear inputs (what must exist before) and outputs (what it produces)
- Own its own slug, branch, and ticket tag

Be honest about the dependency graph. Most "sequential" work has hidden parallelism if you slice along seams instead of layers.

### 5. Identify the seams

A seam is a shared boundary that multiple slices touch. Common seams:

- An API contract between two services
- A database schema two slices both modify
- A shared module or library
- A configuration surface

For each seam, document the agreement: what shape it has, who owns it, what the consumer slices can assume. The seam doc is the central artifact teammates and future-you read when a slice starts to drift across a boundary it shouldn't.

### 6. Assign trust markers

For each slice, assign a default trust marker (`auto` / `review` / `pair`). This propagates into its `plan-<slug>.md` and downstream tickets. See **Trust Markers** below.

### 7. Create the directory

```bash
mkdir -p .docs/<name>
```

### 8. Write slices.md

Use this template. Adapt freely.

````markdown
# <Initiative Title>

> One-line summary of the initiative.

## Why

Why this initiative matters. Customer or business problem, or technical opportunity.

## Goals

- Goal 1
- Goal 2

## Success Criteria

How we'll know this is done.

- [ ] Criterion 1
- [ ] Criterion 2

## Scope

### In scope

- ...

### Out of scope

- ...

## Slices

### 1. <slice-title> — `<slug>`

- **Status**: planned | in-progress | complete
- **Description**: What this slice ships.
- **Depends on**: None | `<other-slug>`, `<other-slug>`
- **Parallel-safe with**: `<other-slug>` (slices that can run concurrently)
- **Trust**: auto | review | pair
- **Plan file**: `.docs/<name>/plan-<slug>.md` (created by `/plan`)

### 2. <slice-title> — `<slug>`

...

## Dependency graph

Visualize parallelism. ASCII is fine.

```

A ──┬─▶ C ──▶ E
└─▶ D ─────╮
B ─────────────┴─▶ F

```

Slices on the same row with no shared edge can ship in parallel. The graph is the contract you and any teammates agree to.

## Seams

### <Seam name> — e.g., "auth API contract"

- **Shape**: What this boundary looks like (interface, schema, etc.)
- **Owner**: Which slice defines it
- **Consumers**: Which slices depend on it
- **Agreement**: What must hold across the boundary
- **Risk if drifts**: What breaks if a slice violates the agreement

## Notes

_Sequencing decisions, risks, open questions, coordination points._
````

### 9. Summarize

Show:

- Initiative name and folder
- Goals and success criteria
- Numbered list of slices with slugs, dependencies, and trust markers
- Named seams
- Parallelizable groups
- Prompt: "Run `/plan <slug>` to design the first slice. Independent slices can be built in parallel — see **Parallel Slices** below."

---

## Trust markers

Default trust marker per slice:

- **auto** — implement-and-commit autonomy; review at PR.
- **review** — implement, commit, but human reviews at PR boundary (default).
- **pair** — agent surfaces decisions before each material step.

Pair-level slices typically include: schema migrations, security-sensitive code, anything touching seams shared with other teams, irreversible changes.

For deeper reasoning — the five-rung framework, classification criteria, and when to climb the ladder — load the `trust-ladder` skill.

---

## Parallel slices

When the dependency graph shows independent slices, they can be built in parallel. Recommended pattern:

```bash
git worktree add ../<repo>-<slug-a> tb/<slug-a>
git worktree add ../<repo>-<slug-b> tb/<slug-b>
```

Open a fresh OpenCode session per worktree. Each runs its own `/plan <slug>` then `/build <slug>` independently. The shared `slices.md` is the source of truth for the seam contracts they must respect.

The `/build` command will refuse to merge across slice boundaries — if a slice grows to need another's work, the agent stops and surfaces a seam-change proposal.

---

## Update mode

When `slices.md` already exists:

1. Read current state: `slices.md` + any `.docs/<name>/plan-*.md` siblings.
2. Ask the user what to update, or infer from context:
   - **Add slices**: insert new entries
   - **Reorder / re-graph**: adjust dependencies or parallelism
   - **Update status**: mark `in-progress` or `complete`
   - **Revise goals/scope**: based on learnings
   - **Remove slices**: drop dropped scope
   - **Refine seams**: tighten contracts as understanding develops (this is a seam-change — see below)
3. Show what changed and current overall status (N of M slices complete).

### Seam changes

If the update changes a seam's shape after slices have started building against it, treat it as a **seam-change proposal**:

- Capture the old shape, new shape, and consumers affected.
- Surface it explicitly: "Slice <X> needs the auth-token seam to also include `expires_at`. Affected consumers: <Y>, <Z>. Confirm before I update the seam doc?"
- Wait for user approval before editing `slices.md`.

---

## When other commands suggest `/slice`

`/think` and `/plan` may detect work too large for a single PR. They tell the user:

> "This is bigger than a PR. Run `/slice` to break it into vertical slices."

`/intake` recommends `/slice` for spec inputs and engineering initiatives that span multiple PRs.

---

## Guardrails

- Always research the codebase before writing.
- Switch to update mode if `slices.md` exists.
- Never write application code.
- Never touch git or `tk` — that's `/build`.
- Each slice must be sized for a single `/plan`. If anything feels too big, split further.
- Sub-plans live as flat sibling files in this folder (`plan-<slug>.md`), not nested.
- The dependency graph is the contract — be honest about what's actually parallel.

```

```
