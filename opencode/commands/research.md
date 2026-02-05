---
description: Deep codebase exploration to understand relevant files, patterns, and architecture before planning
agent: explore
subtask: true
---

# Codebase Research

Explore a codebase to understand how to approach a task. Produce a research document that will inform implementation planning.

## Input

**Task**: $ARGUMENTS

## Process

1. **Clarify** - Ensure you understand what needs to change and what questions need answers
2. **Explore** - Find relevant files, trace data flow, identify patterns, find similar implementations, check tests
3. **Document** - Produce structured findings

## Output Format

```markdown
# Research: {title}

## Summary

One paragraph: what you learned and recommended approach.

## Relevant Files

| File | Purpose | Relevance |
| ---- | ------- | --------- |

## Architecture & Patterns

Key abstractions, conventions, how the subsystem works.

## Key Insights

Important discoveries, gotchas, constraints, dependencies.

## Recommended Approach

Which approach and why. Note alternatives if relevant.

## Open Questions

Unresolved ambiguities needing human input.
```

## Guidelines

- **Be thorough** - Missing information leads to bad plans
- **Be specific** - Include file paths with line numbers
- **Stay focused** - Only research what's relevant
- **Note uncertainty** - Say so explicitly when unclear
- **Prefer conventions** - Favor existing codebase patterns
