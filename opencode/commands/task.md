---
description: Orchestrate the full research/plan/implement workflow for a task
agent: general
---

# Task Workflow

You are orchestrating the full context engineering workflow for a development task. This workflow emphasizes human review at high-leverage points to catch issues early.

## Input

**Task**: $ARGUMENTS

This may be:

- An Asana task URL (e.g., `https://app.asana.com/0/...`)
- A description of work to be done
- A reference to an existing context directory

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────┐
│  1. GATHER CONTEXT                                          │
│     If Asana URL → fetch task via task-manager agent        │
│     Confirm artifact location with user                     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  2. RESEARCH                                                │
│     Explore codebase, produce research document             │
│     ⏸  Human reviews research, approves or steers           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  3. PLAN                                                    │
│     Create phased implementation plan                       │
│     ⏸  Human reviews plan, approves or steers               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  4. IMPLEMENT                                               │
│     Execute plan phase-by-phase                             │
│     ⏸  Human verifies each phase                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  5. COMPLETE                                                │
│     Optionally update Asana task status                     │
└─────────────────────────────────────────────────────────────┘
```

## Process

### Step 1: Gather Context

**If input is an Asana URL**:

1. Use the task-manager agent to fetch and summarize the task
2. Extract the task title for naming
3. Create slug: slugify title, max 25 chars, lowercase with underscores (snake_case)
4. Ask: "Would you like to assign yourself and update the Asana task to 'In Progress'?"

**If input is a description**:

1. Suggest a short slug based on the description (max 25 chars, snake_case)
2. Or ask the user to provide one

**Confirm artifact location**:

Present the default location and ask for confirmation:

> "I'll save artifacts to `.opencode/projects/{slug}/`. Press enter to confirm or specify a different path."

Create the directory once confirmed:

```bash
mkdir -p {confirmed-path}
```

### Step 2: Research

Invoke the research workflow:

1. Use the explore agent as a subagent to research the codebase
2. Focus on the task requirements from Step 1
3. Present research findings to the user

**Human checkpoint**: Wait for approval before proceeding. The user may:

- Approve and continue to planning
- Request additional research in specific areas
- Provide corrections or additional context

Save research to: `{artifact-path}/research.md`

### Step 3: Plan

Invoke the planning workflow:

1. Use the plan agent as a subagent
2. Incorporate research findings and task requirements
3. Present the implementation plan to the user

**Human checkpoint**: Wait for approval before proceeding. The user may:

- Approve and continue to implementation
- Request plan modifications
- Ask clarifying questions

Save plan to: `{artifact-path}/plan.md`

### Step 4: Implement

Execute the plan:

1. Work through each phase as specified
2. Run verification steps after each phase
3. Report progress and wait for approval between phases

**Human checkpoint**: After each phase, wait for confirmation before proceeding.

### Step 5: Complete

After successful implementation:

1. Summarize what was accomplished
2. If Asana task: Ask if user wants to update task status or add a comment
3. Suggest next steps (PR, additional testing, etc.)

## Guidelines

- **Pause at checkpoints**: Never proceed past a human review point without approval
- **Keep context lean**: Each phase runs as a subagent to preserve main context
- **Save artifacts**: Persist research and plans for future reference
- **Be explicit about phase transitions**: Clearly announce when moving between phases
- **Handle interruptions gracefully**: Work can be resumed from saved artifacts

## Resuming Work

If the user references an existing project directory (e.g., `.opencode/projects/my_task/`):

1. Check what artifacts exist (research.md, plan.md)
2. Offer to continue from where they left off
3. Skip completed phases
