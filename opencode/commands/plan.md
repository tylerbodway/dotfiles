---
description: Plan a change - design and document a PR-sized change ready to build
---

Plan a change. Make design decisions, document trade-offs, and produce a `plan.md` ready for `/build` to break down into tickets.

Input: $ARGUMENTS

---

## Input

The user's request should include a change name (kebab-case) OR a description of what they want to build. If neither is provided, ask.

They may also reference:

- An `intake.md` from `/intake`
- A `thoughts.md` from `/think`
- A `research.md` from `/research`
- A `slices.md` entry from `/slice`
- A spec or other document
- Or just describe the change from scratch

---

## Steps

### 1. Understand what to plan

If no clear input is provided, ask what change they want to plan. Derive a kebab-case **slug** from the change description (e.g., "add user auth" → `add-user-auth`). The slug becomes:

- The folder name: `.docs/<slug>/` (or, for one of several plans under an initiative, the filename suffix: `plan-<slug>.md`)
- The git branch: `tb/<slug>`
- The `tk` tag for tickets: `<slug>`

Confirm the slug with the user if there's ambiguity.

### 2. Check for existing context

Use the Glob tool:

- `.docs/<slug>/` — does the folder exist?
- `.docs/<slug>/intake.md`, `thoughts.md`, `research.md`, `slices.md` — prior work to build on?
- `.docs/*/slices.md` — is this plan part of a larger initiative?

If a plan already exists, ask whether to revise or start fresh.

If prior artifacts exist, read them. Build on the work, don't ignore it.

If a `slices.md` references this change, note the parent and inherit any seam agreements and the slice's trust marker.

### 3. Research the codebase

If `research.md` exists, use it as the primary source plus targeted lookups.

Otherwise do a lightweight investigation: relevant files, integration points, constraints. Use the `explore` subagent via the Task tool.

### 4. Detect oversized scope

If the change is too large for a single PR — multiple distinct subsystems, week-plus of work, multiple natural seams — stop and suggest `/slice`:

> "This is bigger than a PR. Run `/slice` to break it into vertical slices."

Don't force the user to switch, but flag it clearly.

### 5. Choose the file location

- **Standalone plan**: `.docs/<slug>/plan.md`
- **One of several plans under an initiative**: `.docs/<initiative-name>/plan-<slug>.md`

For multi-plan initiatives, the folder is the initiative's folder; each plan is a sibling file.

Create the folder if needed:

```bash
mkdir -p .docs/<folder>
```

### 6. Write the plan

Use this template. Adapt freely — remove sections that don't apply, add sections where content warrants it.

```markdown
# <Change Title>

> One-line summary of what this change accomplishes.

Branch: tb/<slug>
Tag: <slug>
Trust: auto | review | pair

**Initiative**: `<initiative-name>` (if part of a `slices.md`, omit otherwise)

## Context

Why this change is needed. What problem it solves.

## Scope

### In scope

- ...

### Out of scope

- ...

## Approach

High-level technical approach.

## Key decisions

### <Decision>

- **Choice**: What was decided
- **Why**: Reasoning
- **Tradeoff**: What was given up

## Architecture

_Diagrams, data flows, component relationships. ASCII where helpful._

## Files and components

- `path/to/file` — what changes and why

## Alternatives considered

| Approach | Pros | Cons |
| -------- | ---- | ---- |
| ...      | ...  | ...  |

**Decision**: Which approach and why.

## Risks

- ...

## Seam notes

_Only if this change touches boundaries shared with other people or systems._

- **Boundary**: Who owns what
- **Agreements**: Contracts that must hold
- **Dependencies**: Other work that must land first or coordinate
```

The `Branch:`, `Tag:`, and `Trust:` lines in the header are **required**. `/build` reads them to know where to commit, how to tag tickets, and the default trust marker for tickets.

- Branch convention: `tb/<slug>`
- Tag convention: `<slug>`
- Trust default: `review` (use `auto` for low-risk mechanical work, `pair` for seam-touching or irreversible work). When the choice isn't obvious, load the `trust-ladder` skill and use the rung framework to reason it out.

### 7. Summarize

After writing, show:

- Slug, branch, tag, trust marker
- File location
- Scope summary, key decisions, open risks
- If part of an initiative, name the parent
- Prompt: "Run `/build` to break this into tickets and start building."

---

## Seam Awareness

If the change touches shared boundaries:

- Include the **Seam Notes** section
- Call out interfaces and contracts in the architecture section
- Flag coordination needs

For solo work, skip seam content entirely.

---

## Guardrails

- Always research the codebase (or use existing `research.md`) before writing.
- Build on prior artifacts. Don't ignore `intake.md`, `thoughts.md`, `research.md`, or a parent `slices.md`.
- Always include `Branch:`, `Tag:`, and `Trust:` in the header.
- Detect oversized scope and suggest `/slice` rather than producing a sprawling plan.
- Never write application code — this is design only.
- Never touch git or `tk` — `/build` does that.
- Verify the file exists after writing.
