---
description: Create or update a roadmap - plan a multi-change initiative that spans several focused changes
---

Create or update a roadmap for an initiative too large for a single change. A roadmap breaks a big idea into ordered, focused changes that can each be planned and built independently.

A roadmap lives in `.docs/<name>/roadmap.md`. Sub-changes are flat sibling folders (e.g., `.docs/<sub-change>/`) that reference the parent roadmap.

Input: $ARGUMENTS

---

## Input

The user's request should include a name (kebab-case) OR a description of the initiative. If neither is provided, ask.

They may also reference:
- A `thoughts.md` from a `/think` session
- A spec or document describing the initiative
- An existing roadmap to update

---

## Steps

### 1. Understand the initiative

If no clear input is provided, ask:
> "What initiative do you want to plan? Describe the big picture -- what you're trying to accomplish across multiple changes."

From their description, derive a kebab-case name (e.g., "redesign the auth system" -> `redesign-auth`).

Read any referenced artifacts (`thoughts.md`, specs, prior research) for context.

**Do NOT proceed without understanding the initiative.**

### 2. Check for existing context

Use the Glob tool to check:

- `.docs/<name>/` -- does this folder already exist?
- `.docs/<name>/roadmap.md` -- does a roadmap already exist?
- `.docs/*/plan.md` -- are there existing changes that relate?
- `.docs/archive/*/plan.md` -- are there completed changes that relate?

**If a roadmap already exists**, switch to update mode (see "Updating a Roadmap" below).

### 3. Research the codebase

Before writing the roadmap, investigate the codebase to ground it in reality:
- Search for relevant files, patterns, and existing implementations
- Identify major components and boundaries involved
- Surface constraints or complexity that should inform how the work is split

Use the Task tool with the `explore` subagent for codebase exploration. This should be broader than a single-change investigation -- you're mapping the landscape.

### 4. Create the directory

```bash
mkdir -p .docs/<name>
```

### 5. Create roadmap.md

Write `.docs/<name>/roadmap.md` using this template:

```markdown
# <Initiative Title>

> One-line summary of the initiative.

## Why

Why this initiative matters. What problem or opportunity it addresses.

## Goals

- Goal 1
- Goal 2

## Success Criteria

How we'll know this initiative is complete and successful.

- [ ] Criterion 1
- [ ] Criterion 2

## Scope

### In scope
- ...

### Out of scope
- ...

## Changes

### 1. `<change-name>`
**Status**: planned | in-progress | complete
**Description**: What this change accomplishes.
**Dependencies**: None | list of prior changes that must land first

### 2. `<change-name>`
**Status**: planned
**Description**: What this change accomplishes.
**Dependencies**: `<prior-change-name>`

### N. ...

## Seam Notes

_If this initiative touches boundaries shared with other people or systems, document them here. Otherwise, remove this section._

- **Shared boundaries**: What interfaces or contracts span this initiative
- **Coordination**: Who else needs to be aware or involved

## Notes

_Sequencing considerations, risks, or open questions about the roadmap._
```

**Roadmap guidelines:**
- Each change should be a coherent unit that could be planned and built independently
- Order changes so dependencies are satisfied
- Prefer smaller, focused changes over large monoliths
- Include enough description that `/plan` can pick up each change with context
- Mark initial status as `planned` for all changes
- Sub-changes will be flat sibling folders: `.docs/<change-name>/plan.md` referencing the parent roadmap

### 6. Summarize

After creating the roadmap, show:
- Initiative name and location
- Brief summary of why and goals
- Numbered list of changes from the roadmap
- Prompt: "Run `/plan <change-name>` to start planning the first change."

---

## Updating a Roadmap

When the roadmap already exists:

### Read current state
- Read `roadmap.md`
- Read `thoughts.md` if it exists in the same folder
- Check `.docs/*/plan.md` for changes that reference this roadmap
- Check `.docs/archive/*/plan.md` for completed changes

### Determine what to update
Ask the user what they want to change, or infer from context:
- **Add changes**: Insert new entries in the changes list
- **Reorder**: Adjust sequencing
- **Update status**: Mark changes as `in-progress` or `complete`
- **Revise goals/scope**: Update based on learnings
- **Remove changes**: Drop items that are no longer needed

### Show diff
After updating, summarize what changed:
- What was added, removed, or modified
- Current status of the roadmap (N of M changes complete)

---

## Roadmap Detection (for other commands)

Other commands (`/think`, `/plan`) may detect that work is too large for a single change. When they suggest `/roadmap`, they should tell the user:

- "This feels like it should be a roadmap with multiple changes."
- "Run `/roadmap` to break it into focused pieces."

---

## Guardrails

- Always research the codebase before writing the roadmap
- If context is critically unclear, ask the user
- If a roadmap with that name already exists, switch to update mode
- Verify the artifact file exists after writing
- Never write application code -- this is planning only
- Changes in the roadmap should be sized for `/plan` -- if any feel too large, break them down further
- Sub-changes are flat sibling folders with references, not nested directories
