---
description: Archive a completed change - date-stamp and move to .docs/archive/
---

Archive a completed change by moving its folder from `.docs/` to `.docs/archive/`.

Input: $ARGUMENTS

---

## Input

Optionally specify a change name. If omitted, infer from conversation context or prompt the user.

---

## Steps

### 1. Select the change

If a name is provided, use it. Otherwise:
- Infer from conversation context
- Use the Glob tool to find `.docs/*/plan.md` (exclude `.docs/archive/`)
- If multiple active changes exist, let the user choose
- **Do NOT auto-select** -- always confirm with the user

### 2. Check task completion

Read `.docs/<name>/tasks.md` (if it exists) and count tasks:
- `- [x]` = complete
- `- [ ]` = incomplete

**If incomplete tasks exist**:
- Show warning: "N tasks are still incomplete."
- Ask if the user wants to proceed anyway.
- Proceed only if confirmed.

**If no tasks.md exists**: proceed without warning.

### 3. Archive the change

Generate the archive directory name using today's date: `YYYY-MM-DD-<change-name>`

```bash
mkdir -p .docs/archive
mv .docs/<name> .docs/archive/YYYY-MM-DD-<name>
```

**If the target already exists**: fail with an error and suggest renaming.

### 4. Update roadmap reference (if applicable)

If the change's `plan.md` referenced a parent roadmap:
- Read `.docs/<roadmap-name>/roadmap.md`
- Update the change's status in the roadmap to `complete`
- If all changes in the roadmap are archived, note that the initiative may be complete

### 5. Show summary

```
## Archive Complete

**Change:** <change-name>
**Archived to:** .docs/archive/YYYY-MM-DD-<name>/

All tasks complete.
```

Or with warnings:

```
## Archive Complete (with warnings)

**Change:** <change-name>
**Archived to:** .docs/archive/YYYY-MM-DD-<name>/

**Warnings:**
- Archived with N incomplete tasks
```

---

## Guardrails

- Always confirm change selection with the user
- Don't block archive on warnings -- inform and confirm
- Show clear summary of what happened
- Update parent roadmap if applicable
