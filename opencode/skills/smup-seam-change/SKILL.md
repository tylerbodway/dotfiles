---
name: smup-seam-change
description: Draft a seam-change proposal when a scope agreement needs to shift mid-build. Use when a builder discovers during implementation that a seam definition, API contract, or scope boundary needs to change.
---

# Seam Change

Draft a structured proposal for changing a seam agreement during the build phase. When implementation reveals that a scope agreement doesn't hold -- an API shape needs to shift, a data model doesn't work as expected, a scope boundary needs to move -- this skill helps you write a clear, concise proposal for the affected builders.

This maps to [Technique 4: Seam-change proposals](https://github.com/tylerbodway/seam-up/blob/main/docs/05-techniques.md) and [Principle 5: Seam changes are the highest-priority communication](https://github.com/tylerbodway/seam-up/blob/main/docs/04-principles.md). The goal is to surface the change quickly without interrupting flow -- draft the proposal, share it, and continue working on non-blocked parts of your scope.

## Input

The user provides:

- What changed or needs to change
- Optionally, the scope split document or existing seam agreements for reference

If the user hasn't described the change, ask:

> What seam needs to change? Describe what you expected the agreement to be and what you've discovered during implementation.

## Steps

### 1. Understand the change

Clarify what's shifting. Ask if needed:

- **Which seam is affected?** Between which scopes?
- **What was the original agreement?** What did the scope split document say?
- **What needs to change?** The new shape, contract, or boundary.
- **Why?** What did implementation reveal that wasn't known during shaping?

### 2. Assess the impact

Think through who and what is affected:

- **Which builders are impacted?** Anyone whose scope touches this seam.
- **What work is affected?** Has code already been written against the original agreement? Will it need to change?
- **Are there downstream seams?** Does this change ripple to other seam agreements?
- **Is any work blocked?** Can the affected builders continue on other parts of their scope, or does this block them?

### 3. Draft the proposal

Write a concise proposal using the template below. The proposal should be self-contained -- a reader should understand the change, the reason, and the impact without needing to ask follow-up questions.

Ask the user where to write the output or whether they'd prefer the proposal as inline text they can paste into a discussion thread, PR comment, or message.

## Output template

```markdown
# Seam Change: <brief title>

**Seam**: <Scope A> / <Scope B>
**Proposed by**: <builder name>
**Date**: <date>

## What changed

<The original agreement and what needs to replace it. Be specific --
show the old and new interface, data shape, or boundary definition.
If code examples help clarify, include them.>

## Why

<What implementation revealed. What assumption didn't hold? What new
constraint or opportunity emerged?>

## Impact

<Who is affected and how. What existing work needs to change? Are
there downstream effects on other seams? Is anything blocked?>

## Proposal

<The specific change being proposed. If there are multiple options,
present them with tradeoffs. Recommend one if you have a preference.>

## Status

- [ ] Proposed
- [ ] Accepted / Renegotiated
- [ ] Scope split updated
```

Keep the proposal concise. A seam-change proposal that takes longer to write than the change itself is too heavy. If the change is simple, the proposal should be a few lines. If it's complex, the detail is warranted.

## Guardrails

- Seam-change proposals are **shared artifacts**. They communicate across scope boundaries. Write for the audience: another builder who needs to understand what's changing in their scope.
- Don't make the change unilaterally. The proposal is a request, not a notification. The affected builder reviews and either accepts, negotiates, or pushes back.
- If the change is trivial (typo in a field name, minor type adjustment), suggest the user just communicate it directly rather than writing a formal proposal. This skill is for changes with real impact.
- Per [Principle 4](https://github.com/tylerbodway/seam-up/blob/main/docs/04-principles.md), scope agreements update only through this kind of proposal process. Once the build phase begins, the scope split document is the baseline and changes are tracked.
- Frame the proposal neutrally. Present the facts and the options. Don't frame it as a failure that the original agreement was wrong -- shaping is always based on incomplete information, and discovering better approaches during building is expected.
