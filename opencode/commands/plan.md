---
description: Create a phased implementation plan with testing and verification steps
agent: plan
subtask: true
---

# Implementation Planning

Create a detailed implementation plan based on research findings. Produce a plan that can be executed phase-by-phase with clear verification at each step.

## Input

**Task**: $ARGUMENTS

If research was conducted, it should be provided above. If no research exists and the task is complex, recommend running `/research` first.

## Process

1. **Review context** - Understand research findings, recommended approach, relevant files
2. **Identify phases** - Break work into small, verifiable, independent steps
3. **Document plan** - Produce structured implementation plan

## Output Format

```markdown
# Plan: {title}

## Overview

One paragraph: approach and expected outcome.

## Phases

### Phase 1: {name}

**Goal**: What this accomplishes
**Files**: `path/to/file.rb` - what changes
**Steps**: Numbered list of specific actions
**Verification**: Checkboxes for tests/checks to confirm success

### Phase 2: {name}

(same structure)

## Testing Strategy

Unit tests, integration tests, manual verification.

## Rollback Plan

How to undo if something goes wrong.

## Open Questions

Resolve before implementing.
```

## Guidelines

- **Be precise** - Specify exact files and changes
- **Keep phases small** - 1-3 files per phase
- **Front-load risk** - Tackle uncertain parts early
- **Match conventions** - Follow patterns from research
- **Include verification** - Every phase needs success criteria
- **Consider tests first** - Often easier to write tests before implementation
