---
name: openspec-new-epic
description: Create a new epic in openspec/epics/. Use when the user wants to plan a high-level initiative that spans multiple OpenSpec changes, or when they mention creating an epic, umbrella project, or multi-change initiative.
---

Create a new epic — a high-level initiative that spans multiple OpenSpec changes.

Epics live in `openspec/epics/<epic-name>/` and contain three artifacts:

- `vision.md` — Goal, success criteria, scope
- `roadmap.md` — Phased sequence of OpenSpec changes
- `decisions.md` — Cross-change architectural decisions (ADRs)

Epics are **not** managed by the OpenSpec CLI. They are a manually-managed convention
that provides persistent context across related changes.

**Input**: An epic name (kebab-case) OR a description of the initiative.

**Steps**

1. **If no clear input provided, ask what they want to plan**

   Use the **AskUserQuestion tool** (open-ended, no preset options) to ask:

   > "What initiative do you want to plan? Describe the high-level goal that will span multiple changes."

   From their description, derive a kebab-case name (e.g., "user onboarding flow" → `user-onboarding`).

   **IMPORTANT**: Do NOT proceed without understanding what the user wants to build.

2. **Check if the epic already exists**

   Look for `openspec/epics/<name>/`. If it exists, inform the user and suggest using
   `/opsx-update-epic` to modify it instead.

3. **Create the epic directory and vision.md**

   ```
   openspec/epics/<name>/
   ├── vision.md
   ├── roadmap.md
   └── decisions.md
   ```

   Create all three files. Use the templates below as structure, filling them in based
   on the user's description and any codebase context you gather.

4. **If context is unclear, ask clarifying questions**

   Before writing, you may need to clarify:
   - Scope boundaries (what's in vs. out)
   - Success criteria (how will they measure done?)
   - Known constraints or dependencies

   Prefer making reasonable assumptions to keep momentum, but ask if something
   is genuinely ambiguous.

5. **Show what was created**

   Summarize the epic and its artifacts.

**Templates**

### vision.md

```markdown
# Epic: <Title>

## Goal

<High-level objective. What does success look like when this epic is complete?>

## Success Criteria

- <Measurable outcome>
- <Measurable outcome>

## Scope

### In Scope

- <What this epic covers>

### Out of Scope

- <What this epic explicitly does NOT cover>
```

### roadmap.md

```markdown
# Roadmap

## Phase 1: <Name>

- [ ] `<change-name>` — <Brief description>
- [ ] `<change-name>` — <Brief description>

## Phase 2: <Name>

- [ ] `<change-name>` — <Brief description>

## Dependencies

- <Cross-phase or cross-change dependency>
```

### decisions.md

```markdown
# Architectural Decisions

## ADR-001: <Title>

**Context**: <What forces are at play? Why does this span multiple changes?>

**Decision**: <What was decided?>

**Consequences**: <What must all related changes adhere to?>
```

**Output**

After creating the epic, summarize:

- Epic name and location
- The goal (from vision.md)
- Number of phases and changes in the roadmap
- Prompt: "To start working on the first change, run `/opsx-new <first-change-name>` or `/opsx-ff <first-change-name>`. Reference this epic in your proposal."

**Guardrails**

- Write files to `openspec/epics/<name>/`, NOT to `openspec/changes/`
- Always create all three files (vision.md, roadmap.md, decisions.md)
- Use kebab-case for the epic directory name
- If the epic name conflicts with an existing one, ask for a different name
- Change names in the roadmap should be valid kebab-case, suitable for `openspec new change <name>`
- Do NOT run any `openspec` CLI commands — epics are outside the CLI
