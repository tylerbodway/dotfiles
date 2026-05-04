---
description: Archive a completed change folder - verify all tickets are closed, date-stamp, and move to the archive
---

Archive a completed change folder. The folder is the unit of completion: a standalone `.docs/<slug>/` (one `plan.md`) or an initiative `.docs/<name>/` (one `slices.md` + N `plan-<slug>.md` siblings). Archive moves the **whole folder** to `.docs/archive/YYYY-MM-DD-<name>/`.

Slice completion within an initiative does **not** trigger an archive. Slices are marked complete in `slices.md` as their tickets close (during `/build`). The initiative folder is archived only once every slice is complete.

Input: $ARGUMENTS

---

## Input

Optionally specify a folder name under `.docs/`. If omitted, infer from conversation context or prompt the user.

---

## Steps

### 1. Select the folder

If a name was passed, use it. Otherwise:

- Infer from conversation context.
- Use Glob to find `.docs/*/` folders containing a `plan.md` or `slices.md`, excluding `.docs/archive/`.
- If multiple candidates, let the user choose.
- **Always confirm the selection with the user.** Do not auto-select.

### 2. Detect folder shape

Look at the folder contents:

- **Standalone**: contains `plan.md`. One slug. Archive moves the whole folder when its tickets are closed.
- **Initiative**: contains `slices.md` (and typically multiple `plan-<slug>.md` files). Multiple slugs. Archive moves the whole folder when **all** slices are complete.

A folder with both `plan.md` and `slices.md` is unusual — surface it and ask the user which mode applies.

### 3. Resolve the slugs

Collect all relevant slugs:

- **Standalone**: read `plan.md` header for the `Tag:` value. Fall back to the folder name if missing.
- **Initiative**: for each `plan-*.md`, read its `Tag:`. Also read `slices.md` to know the canonical slug list. Fall back to the filename suffix if a `Tag:` is missing.

### 4. Verify completion

For each slug, run:

```bash
tk ready -T <slug>
tk blocked -T <slug>
```

Both should be empty. Any ticket still `open` or `in_progress` blocks a clean archive.

**For an initiative**, also read `slices.md` and verify every slice's `Status:` is `complete`. A slice marked anything other than `complete` blocks the archive.

If anything is incomplete, show:

```
## Cannot cleanly archive: <name>

Open tickets:
- <slug> / <id> [<status>] — <title>

Incomplete slices (initiative only):
- <slug> [<status>]

Archive anyway? (this strands work-in-progress)
```

Wait for confirmation. Proceed only if the user opts in.

### 5. Move the folder

```bash
mkdir -p .docs/archive
mv .docs/<name> .docs/archive/YYYY-MM-DD-<name>
```

If the target already exists (same name archived earlier today), fail and ask the user how to disambiguate.

### 6. Summarize

```
## Archived: <name>

Shape: standalone | initiative
Moved to: .docs/archive/YYYY-MM-DD-<name>/
Slugs: <slug>, <slug>
Tickets: all closed (or: archived with N open tickets)
Slices: all complete (or: archived with N incomplete slices)
```

---

## What about completing a single slice mid-initiative?

This is **not** an `/archive` operation. When a slice's tickets all close during `/build`:

- `/build` updates the slice's `Status:` in `slices.md` to `complete`.
- The `plan-<slug>.md` stays in place inside the initiative folder.
- Other slices in the initiative continue (possibly in parallel worktrees).

The initiative folder waits intact until every slice is done. Then `/archive` moves the whole thing.

If you genuinely want to "retire" a single slice that's been abandoned (not completed), that's a `/slice` update-mode operation: remove the slice from `slices.md` and delete or move the `plan-<slug>.md` manually. `/archive` is for completion, not abandonment.

---

## Notes on `tk` tickets after archive

Closed tickets stay in `.tickets/` — a permanent record alongside git history. The archive only moves design artifacts. The relationship between an archived plan and its tickets is preserved through the slug tag and the commit messages that reference each ticket ID.

---

## Guardrails

- The folder is the unit. Never archive an individual `plan-<slug>.md` out of an initiative folder.
- For initiatives, require every slice complete before archiving (or explicit override).
- Always confirm folder selection — never auto-select.
- Always check `tk` ticket status before moving. Inform and confirm if anything is open.
- Never delete tickets. They stay in `.tickets/`.
- Never delete artifacts. Archive moves; it does not destroy.
- If the archive target already exists, ask — don't overwrite.
