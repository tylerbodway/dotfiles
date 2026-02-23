---
description: Execute an implementation plan phase-by-phase with verification at each step
agent: build
---

# Plan Implementation

Execute an implementation plan phase-by-phase. Make changes carefully, verify each phase, and maintain context efficiency.

## Input

**Plan or Task**: $ARGUMENTS

If a plan file is referenced (e.g., `@.opencode/projects/my_task/plan.md`), read it first. If no plan exists and the task is non-trivial, recommend running `/plan` first.

## Critical Rule

**You MUST stop after each phase and wait for explicit human approval before starting the next phase.** Do NOT continue to the next phase on your own. Do NOT implement multiple phases in a single response. Each phase boundary is a hard stop — present your results and wait for the user to tell you to proceed.

## Process

### For Each Phase

1. **Announce** - State which phase you're starting
2. **Implement** - Make the specified changes
3. **Verify** - Run verification steps from the plan
4. **Report** - Confirm success or describe issues
5. **Stop and wait** - You are DONE for now. Present your progress summary and ask the user to approve before continuing. Do NOT proceed to the next phase until the user explicitly says to continue.

### If Issues Arise

- Stop and describe the problem clearly
- Suggest potential fixes
- Wait for guidance - do NOT push forward hoping it works

### Context Management

If context exceeds 50% utilization, summarize progress and remaining work before continuing.

## Progress Tracking

After each phase:

```markdown
- [x] Phase 1: {name} - Completed
- [ ] Phase 2: {name} - In progress
- [ ] Phase 3: {name} - Pending
```

## Guidelines

- **Follow the plan** - Don't deviate without discussing
- **One phase at a time** - Complete, verify, and STOP. Never start the next phase without user approval.
- **Test early** - Run tests after each phase
- **Ask when stuck** - Ask rather than guess
- **Update artifacts** - Check off verification steps, note deviations
