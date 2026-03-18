---
description: Plan a change - scope, design, and document a change ready for implementation
---

Plan a change -- scope it, make key design decisions, and produce a plan ready for `/implement`.

This takes any combination of prior artifacts (`thoughts.md`, `research.md`, a spec, a roadmap reference) or a fresh prompt and produces a `plan.md` (or multiple `plan-{topic}.md` files for complex changes) that covers what, why, how, and the tradeoffs involved.

Input: $ARGUMENTS

---

## Input

The user's request should include a change name (kebab-case) OR a description of what they want to build. If neither is provided, ask.

They may also reference:
- A `thoughts.md` from a `/think` session
- A `research.md` from a `/research` session
- A `roadmap.md` entry from a `/roadmap` session
- A spec or other document
- Or just describe what they want from scratch

---

## Steps

### 1. Understand what to plan

If no clear input is provided, ask:
> "What change do you want to plan? Describe what you want to build or fix."

From their description, derive a kebab-case name (e.g., "add user authentication" -> `add-user-auth`).

**Do NOT proceed without understanding what the user wants to build.**

### 2. Check for existing context

Use the Glob tool to check:

- `.docs/<name>/` -- does this change folder already exist?
- `.docs/<name>/thoughts.md` -- prior thinking to build on?
- `.docs/<name>/research.md` -- prior codebase research?
- `.docs/*/roadmap.md` -- is there a parent roadmap?

**If a plan already exists**, ask the user if they want to revise it or start fresh.

**If prior artifacts exist** (`thoughts.md`, `research.md`), read them for context. The plan should build on prior work, not ignore it.

**If a roadmap references this change**, read the roadmap for broader context. The plan should reference the parent roadmap.

### 3. Research the codebase

If no `research.md` exists, do lightweight codebase investigation before writing the plan:
- Search for relevant files, patterns, and existing implementations
- Identify integration points and dependencies
- Surface constraints or complexity that should inform the plan

If `research.md` already exists, use it as the primary source and supplement with targeted lookups as needed.

Use the Task tool with the `explore` subagent for any codebase exploration.

### 4. Create the change directory

```bash
mkdir -p .docs/<name>
```

### 5. Create plan.md

Write `.docs/<name>/plan.md` using this template:

```markdown
# <Change Title>

> One-line summary of what this change accomplishes.

**Roadmap**: `<roadmap-name>` (if applicable, omit if none)

## Context

Why this change is needed. What problem it solves. Link to parent roadmap if applicable.

## Scope

### In scope
- ...

### Out of scope
- ...

## Approach

High-level technical approach. How the change will be implemented.

## Key Decisions

### <Decision 1>
- **Choice**: What was decided
- **Why**: Reasoning
- **Tradeoff**: What was given up

### <Decision 2>
- ...

## Architecture

_Diagrams, data flows, component relationships. Use ASCII diagrams where helpful._

## Files & Components

Key files/components that will be created or modified:
- `path/to/file` -- what changes and why

## Alternatives Considered

| Approach | Pros | Cons |
| -------- | ---- | ---- |
| ...      | ...  | ...  |

**Decision**: Which approach and why.

## Risks & Open Questions

- ...

## Seam Notes

_If this change touches boundaries shared with other people or systems, document them here. Otherwise, remove this section._

- **Scope boundary**: Who owns what
- **Agreements**: What contracts or interfaces must hold
- **Dependencies**: What other work must land first or coordinate
```

Adapt the template to fit the change. Remove sections that aren't relevant. Add sections where the content warrants it.

### 6. Complex plans -- multiple files

If the plan is too large or covers distinct topics that are better separated:

- Create `plan-{topic}.md` files instead of a single `plan.md`
- Each file follows the same template structure
- Add a brief `plan.md` that serves as an index linking to the topic files

This should be rare. Prefer a single `plan.md` unless the complexity genuinely warrants splitting.

### 7. Summarize

After creating the plan, show:
- Change name and location
- Brief summary of scope and approach
- Key decisions made
- Open risks or questions
- If part of a roadmap, note which one
- Prompt: "Run `/implement` to start building, or `/research` to investigate further."

---

## Roadmap Detection

If during planning you realize the scope is too large for a single change:

1. Tell the user: "This feels like it should be a roadmap with multiple changes."
2. Offer to run `/roadmap` instead to break it into focused pieces.
3. If the user agrees, stop and let them invoke `/roadmap`.
4. If the user wants to continue anyway, proceed but note the risk of scope creep.

---

## Seam Awareness (Adaptive)

If the change touches boundaries shared with other people or systems:
- Include the "Seam Notes" section in `plan.md`
- Call out interfaces and contracts that others depend on in the architecture section
- Flag areas where coordination is needed

For solo projects, skip seam sections entirely.

---

## Guardrails

- Always research the codebase (or reference existing `research.md`) before writing the plan
- Build on prior artifacts (`thoughts.md`, `research.md`) when they exist -- don't ignore prior work
- If context is critically unclear, ask the user -- but prefer making reasonable decisions to keep momentum
- If a plan with that name already exists, ask what to do
- Verify the artifact file exists after writing
- Never write application code -- this is planning only
- Reference parent roadmap if one exists
