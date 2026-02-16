---
name: openspec-update-epic
description: Update an existing epic's roadmap, decisions, or vision. Use when the user wants to modify an epic, mark changes as complete, add new architectural decisions, or revise scope after completing changes.
---

Update an existing epic in `openspec/epics/`.

Use this after completing changes, when scope shifts, or when new cross-cutting
decisions emerge. Keeps the epic's artifacts in sync with reality.

**Input**: An epic name OR a description of what to update.

**Steps**

1. **If no epic name provided, list available epics**

   List directories under `openspec/epics/` and ask the user which one to update.

   If no epics exist, suggest creating one with `/opsx-new-epic`.

2. **Read the current epic artifacts**

   Read all three files in `openspec/epics/<name>/`:
   - `vision.md`
   - `roadmap.md`
   - `decisions.md`

3. **Determine what to update**

   If the user didn't specify, ask what they want to update:
   - **Roadmap** — Mark changes complete, add new changes, reorder phases
   - **Decisions** — Add a new ADR or revise an existing one
   - **Vision** — Adjust goal, success criteria, or scope

   If the user's intent is clear from context (e.g., "mark add-email-auth as done"),
   skip asking and proceed.

4. **Check archived changes for context**

   When marking roadmap items complete, optionally check `openspec/changes/archive/`
   for the corresponding archived change to confirm it was actually completed.

5. **Make the updates**

   Edit the relevant file(s). Preserve existing content — don't rewrite sections
   that haven't changed.

6. **Show what changed**

   Summarize the updates made. If roadmap items were completed, show overall
   epic progress (e.g., "Phase 1: 2/3 complete").

**Roadmap Update Patterns**

Mark a change as done:

```markdown
- [x] `add-email-auth` — Email/password signup and login
```

Add a new change discovered during implementation:

```markdown
- [ ] `fix-oauth-redirect` — Handle edge case in OAuth callback (added mid-epic)
```

**Decision Update Pattern**

New ADRs get the next sequential number:

```markdown
## ADR-002: <Title>

**Context**: <What changed or was discovered?>

**Decision**: <What was decided?>

**Consequences**: <Impact on remaining changes>
```

**Output**

After updating, summarize:

- What was changed and in which file(s)
- Current epic progress (if roadmap was updated)
- What's next: the next incomplete change in the roadmap, if any

**Guardrails**

- Only modify files in `openspec/epics/<name>/`
- Preserve content that wasn't explicitly asked to change
- Do NOT run any `openspec` CLI commands — epics are outside the CLI
- If an epic doesn't exist, suggest creating it with `/opsx-new-epic`
- Keep ADR numbering sequential
