---
description: Implement a planned change - build tasks step-by-step from a plan, pausing at commit boundaries for approval
---

Implement a planned change, working through steps with user approval at each boundary.

If a `tasks.md` exists, follow it. Otherwise, build one from the plan first.

Input: $ARGUMENTS

---

## Input

Optionally specify a change name. If omitted, infer from conversation context or prompt the user.

---

## Steps

### 1. Select the change

If a name is provided, use it. Otherwise:
- Infer from conversation context if the user mentioned a change
- Auto-select if only one active change exists (has a `plan.md` but is not in archive)
- If ambiguous, use the Glob tool to find `.docs/*/plan.md` (exclude `.docs/archive/`) and let the user choose

Always announce: "Implementing: **<name>**"

### 2. Read context

Read all artifacts for the selected change:
- `.docs/<name>/plan.md` (or `plan-*.md` files) -- understand what, why, and how
- `.docs/<name>/research.md` -- understand the codebase landscape (if exists)
- `.docs/<name>/tasks.md` -- understand implementation steps (if exists)

If a roadmap is referenced in `plan.md`, also read `.docs/<roadmap-name>/roadmap.md` for broader context.

**If no plan.md exists**, tell the user and suggest running `/plan` first.

### 3. Build tasks.md if missing

If `tasks.md` doesn't exist, create it from the plan before starting implementation.

Tasks must be grouped into steps. Each step is a commit-like unit of work that keeps the project in a green state. A step may contain one or more related tasks. Include verification for each step.

Write `.docs/<name>/tasks.md` using this structure:

```markdown
# Tasks: <Change Title>

## Step 1: <Description of first logical unit>

- [ ] Task description
- [ ] Task description
- [ ] **Verify**: How to confirm this step is complete (test command, manual check, etc.)

## Step 2: <Description of next logical unit>

- [ ] Task description
- [ ] Task description
- [ ] **Verify**: How to confirm this step is complete

## Step N: ...
```

**Grouping guidelines:**
- Each step should leave the project in a working state (tests pass, no broken imports)
- Group related tasks that should be committed together
- Testing is bundled with behavior changes, not separated into its own step
- Include a verification task at the end of each step
- Steps should be ordered so dependencies are satisfied
- Prefer smaller, focused steps over large ones
- Each step should tell part of the story of the overall change, building on the previous steps

After creating tasks.md, show it to the user and confirm before starting implementation.

### 4. Show current progress

Parse `tasks.md` to determine progress:
- Count completed (`- [x]`) vs pending (`- [ ]`) tasks
- Identify which step is current (first step with pending tasks)

Display:
```
## Implementing: <change-name>

Progress: N/M tasks complete
Current step: Step X - <description>
```

### 5. Implement tasks step by step

Work through tasks within the current step:

a. **For each pending task in the current step**:
   - Announce which task you're working on
   - Make the code changes required
   - Keep changes minimal and focused
   - Mark the task complete in tasks.md: `- [ ]` -> `- [x]`

b. **When you reach a Verify task**:
   - Execute the verification (run tests, check types, etc.)
   - If verification fails, fix the issue before proceeding
   - Mark the verify task complete

c. **At the end of each step, pause for user approval**:
   ```
   ## Step X Complete

   Completed:
   - [x] Task 1
   - [x] Task 2
   - [x] Verify: ...

   Ready for Step X+1: <description>

   Continue?
   ```
   Wait for the user to confirm before starting the next step.

d. **If a task is unclear**, pause and ask for clarification before implementing.

e. **If implementation reveals a design issue**, pause and suggest updating artifacts:
   - "This doesn't work as planned. The issue is: <description>"
   - "Options: 1) Update plan.md and continue, 2) Rethink the approach"
   - Wait for guidance

### 6. On completion

When all tasks are complete:

```
## Implementation Complete

**Change:** <change-name>
**Progress:** M/M tasks complete

All steps finished. Run `/archive` to archive this change.
```

### 7. On pause (issue encountered)

If you need to stop mid-implementation:

```
## Implementation Paused

**Change:** <change-name>
**Progress:** N/M tasks complete
**Current step:** Step X - <description>

### Issue
<description of the issue>

### Options
1. <option>
2. <option>

What would you like to do?
```

---

## Task Marking Rules

- Update task checkboxes in `tasks.md` immediately after completing each task
- Use the Edit tool to change `- [ ]` to `- [x]` for the specific task line
- Never mark a task complete before the work is actually done
- If you need to add new tasks discovered during implementation, add them to the appropriate step in `tasks.md`

---

## Step Boundary Behavior

Steps are the approval gates. The agent:
- **Keeps going** through tasks within a single step without pausing
- **Pauses** at the boundary between steps for user approval
- **Always pauses** if an error, blocker, or unclear requirement is encountered
- **Always pauses** if implementation reveals the plan needs to change

This mirrors the git commit model: each step is a logical unit that should leave the project green. The user approves each unit before the next begins.

---

## Fluid Workflow

This command supports fluid interaction with other commands:

- **Allows artifact updates**: If implementation reveals issues, update `plan.md` -- don't treat artifacts as frozen
- **Resumable**: If interrupted, running `/implement` again picks up where you left off by reading task completion state
- **Interleave with /think or /research**: If stuck, suggest the user run `/think` or `/research` to work through the problem

---

## Guardrails

- Always read all context files before starting implementation
- If tasks.md doesn't exist, build it from the plan and confirm with the user before implementing
- Keep code changes minimal and scoped to each task
- Pause on errors, blockers, or unclear requirements -- don't guess
- Update task checkboxes immediately after completing each task
- Respect step boundaries as approval gates
- If all tasks are already complete, suggest archiving
- Never skip verification tasks
