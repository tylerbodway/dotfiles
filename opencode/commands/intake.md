---
description: Intake any new work - classify the input (bug, debt, perf, spec, initiative), scaffold an artifact, and recommend the next mode of planning
---

The front door for any new work. Take a raw input — a bug report, a Linear/Notion link, a Datadog observation, a half-formed idea, a product spec — classify it, capture it as `intake.md`, and recommend the next mode (`/think`, `/research`, `/plan`, `/slice`, or straight to `/build`).

This is **routing, not deciding**. You produce a thin artifact and a recommendation. The user picks the next step.

Input: $ARGUMENTS

---

## Input

Anything: pasted text, a URL, a file path, a one-liner. If empty, ask the user what came in.

Useful starting questions when ambiguous:

- "Is this a bug report, an idea, a spec, or something else?"
- "Where is the source of truth — Linear, Notion, customer email, your head?"
- "Do you already have a slug in mind?"

---

## Steps

### 1. Classify

Pick the closest type. These are not rigid; use judgment.

| Type           | Looks like                                                      | Default next mode                    |
| -------------- | --------------------------------------------------------------- | ------------------------------------ |
| **bug**        | Customer report with repro steps + expected behavior            | `/research` then `/plan`             |
| **debt**       | "I noticed a legacy pattern…" / refactor / cleanup              | `/think` or `/plan`                  |
| **perf**       | APM observation, slow query, N+1, latency target                | `/research` (measure first)          |
| **spec**       | Product spec doc with mockups, acceptance criteria, rollout     | `/research` then `/slice` or `/plan` |
| **initiative** | Self-led engineering project, multi-PR, no direct customer face | `/think` then `/slice`               |
| **idea**       | Half-formed thought, exploratory, not yet a problem             | `/think`                             |

If the work clearly fits a single PR, the next mode is `/plan`. If it spans multiple PRs, it's `/slice`. If unclear, `/research` first.

### 2. Derive the slug

Kebab-case, lowercase, one short phrase. Examples:

- "Customer can't import CSV with quoted commas" → `csv-quoted-import`
- "Remove jQuery" → `remove-jquery`
- "Slow people search endpoint" → `people-search-perf`

Confirm with the user if the slug isn't obvious.

### 3. Check for existing context

Glob `.docs/*/` and `.docs/archive/*/`. If the slug or topic overlaps, surface it:

> "There's already `.docs/<other-slug>/`. Is this related, a duplicate, or genuinely new?"

Don't create a new folder if the user wants to extend existing work.

### 4. For spec inputs: distill, don't transcribe

If `type: spec`, switch to **distillation mode** before writing the artifact. The PM's spec doc stays canonical in Notion (or wherever); the intake captures only the engineering-relevant slice.

**Pull these in:**

- Final decisions and requirements
- Acceptance criteria (becomes Success Criteria)
- Mockup / design links (link, don't paste)
- Rollout, feature-flag, or migration strategy
- Edge cases that are already mapped
- Constraints (legal, privacy, technical, performance, dependencies on other teams, etc.)
- Open questions and risks

**Drop these:**

- Customer research narrative, interview quotes, persona deep-dives
- Discarded alternatives and rabbit-hole explorations
- Meeting notes, Slack threads, internal discussion
- Stakeholder context that doesn't shape the build

**Note what was dropped.** Add a one-line "Dropped from source: …" entry under Notes so nothing is silently hidden. If a planning question later demands the dropped content, the user can re-fetch from Source.

**Stamp the source-reviewed date.** Add `Source reviewed: YYYY-MM-DD` under the header so future sessions know whether the spec may have drifted since intake.

For non-spec types, this step is a no-op — proceed directly to writing the artifact.

### 5. Create the intake artifact

```
mkdir -p .docs/<slug>
```

Write `.docs/<slug>/intake.md` using this template. Adapt freely.

```markdown
# <Title>

> One-line summary of what came in.

**Type**: bug | debt | perf | spec | initiative | idea
**Source**: <Linear URL, Notion URL, customer email, "my head", etc.>
**Source reviewed**: YYYY-MM-DD
**Slug**: <slug>
**Recommended next**: `/research` | `/plan` | `/slice` | `/think`

## Context

What came in. Description of the problem, bug trace, distilled version of the spec, etc. If a URL was provided, summarize the linked content here so a fresh session can pick it up without re-fetching.

## Motivation

Why this matters. Customer impact, codebase health, business value, technical opportunity.

## Success criteria

What "done" looks like. For bugs: the repro no longer reproduces. For specs: acceptance criteria. For perf: a measurable target.

- [ ] ...
- [ ] ...

## Open questions

What needs clarifying, or what the next planning mode needs to determine.

- ...

## Notes

Anything else worth capturing — links, screenshots, related code paths, constraints.
```

### 6. Recommend the next mode

End with a clear handoff:

```
## 📝 Intake captured!

Type: <type>
Slug: <slug>
File: .docs/<slug>/intake.md

Recommended next: `/<mode> <slug>`

Why: <one sentence on why this mode>
```

Stop. The user picks whether to follow the recommendation or override.

---

## Heuristics

- **Don't research.** Intake is fast. Codebase exploration belongs to `/research`.
- **Don't plan.** Don't propose solutions. Capture the problem.
- **Stay thin.** Five minutes max for bugs and ideas. Specs take longer because distillation is real work.
- **For specs: distill, don't transcribe.** The Notion doc stays canonical. The intake is the engineering-relevant slice.
- **Link, don't duplicate** for non-spec sources. Summarize enough that a fresh session can act without re-fetching.
- **Default to `/research` for bugs and perf.** You almost always need to compare against the codebase first.
- **Default to `/think` for ideas.** Don't push half-formed ideas into planning.

---

## Guardrails

- Never write application code.
- Never run `git` or `tk` commands. Those happen later.
- Never make design decisions. Capture, classify, recommend.
- Always create the slug folder if it doesn't exist.
- Always check for existing related work before creating a new folder.
