---
name: trust-ladder
description: Classify work by the appropriate level of AI autonomy. Use when planning changes, annotating scopes or tasks, or deciding how much human oversight a given piece of work needs.
---

# Trust Ladder

Classify each unit of work (a slice, a task, a chore) by how much autonomy
the AI should take and how much human oversight is warranted. The goal is not
to maximize autonomy. The goal is to match the level of oversight to the risk,
ambiguity, and verification cost of the work.

## The Rungs

### Rung 1 -- AI suggests, human writes

The AI proposes an approach or code snippet. The human types the actual
implementation. Use this when the work requires deep domain judgment, the
codebase context is subtle, or you want to internalize something new.

**Signals**: new architectural pattern, unfamiliar domain, high-stakes data
migration, learning opportunity you don't want to skip.

### Rung 2 -- AI writes, human reviews every line

The AI produces the code. The human reads every line before committing. This
is the default for meaningful feature work where correctness matters and the
blast radius is more than trivial.

**Signals**: new domain model, business logic with edge cases, code that
touches money or user data, anything where "close enough" is not good enough.

### Rung 3 -- AI writes and self-tests, human reviews diffs

The AI produces code and runs verification (tests, linter, type checks)
before presenting the result. The human reviews the diff and spot-checks
rather than reading every line. This works when good automated verification
exists and the change follows established patterns.

**Signals**: adding a feature that follows an existing pattern, extending
test coverage, building on a well-tested foundation, clear acceptance
criteria that tests can verify.

**Prerequisite**: meaningful test coverage on the affected code path.

### Rung 4 -- AI works in a worktree, human reviews the PR

The AI operates independently in a separate worktree or branch and produces
a PR for review. The human reviews the PR as they would a colleague's work.
This suits well-scoped, low-risk work with clear boundaries and good CI.

**Signals**: dependency bumps, mechanical refactors, backfilling tests for
stable code, code-mod style changes, moving files, renaming patterns.

**Prerequisites**: CI catches regressions meaningfully, the task scope is
tight and unambiguous, the blast radius is small or fully reversible.

### Rung 5 -- AI runs async, human reviews when notified

The AI runs in a persistent or cloud environment and notifies the human when
done. The human reviews the result cold, without having supervised the process.
This is appropriate only when the task is well-specified, verification is
automated, and failure is cheap to detect and revert.

**Signals**: scheduled dependency updates, flaky test fixes with clear
reproduction, documentation generation, boilerplate scaffolding.

**Prerequisites**: strong CI, clear acceptance criteria, small blast radius,
easy rollback.

## Classification Criteria

When deciding which rung fits a unit of work, weigh these factors:

| Factor            | Lower rung (more oversight)                    | Higher rung (more autonomy)              |
| ----------------- | ---------------------------------------------- | ---------------------------------------- |
| Ambiguity         | Fuzzy requirements, "done" requires taste      | Clear spec, testable acceptance criteria |
| Blast radius      | Touches many systems, hard to revert           | Isolated module, easy rollback           |
| Domain complexity | Business logic lives in people's heads         | Well-documented, pattern-established     |
| Verification      | Manual testing required, no good test coverage | Strong CI, meaningful automated checks   |
| Novelty           | First time doing this kind of thing            | Follows an established pattern           |
| Data sensitivity  | Touches user data, money, permissions          | Touches display code, dev tooling        |

A unit of work belongs on the **lowest rung where any factor raises concern**.
When in doubt, go one rung lower.

## Output Format

When annotating a slice, task, or chore, use a one-line annotation:

```
Rung N -- <brief rationale>
```

Examples:

- `Rung 2 -- new domain model, needs line-by-line review`
- `Rung 3 -- follows existing CRUD pattern, good test coverage on this controller`
- `Rung 4 -- mechanical gem bump, CI will catch regressions`
- `Rung 5 -- scheduled Dependabot-style update, fully automated verification`

## Climbing the Ladder Over Time

A task category can move up a rung when the prerequisites for that rung are
met. The investments that unlock higher rungs:

- **Better test coverage** on critical paths (unlocks rung 3)
- **Faster, more reliable CI** that catches real regressions (unlocks rung 4)
- **Clear, automatable acceptance criteria** for common task types (unlocks rung 4-5)
- **Observability** that surfaces regressions quickly in production (unlocks rung 5)
- **Small, revertible commits** and good git hygiene (unlocks rung 4-5)

Track which categories sit on which rung. When you invest in verification
infrastructure, revisit the classification. The ladder is not static.
