---
name: smup-scope-split
description: Document scope boundaries, design decisions, and seam agreements for a project. Use after a shaping session to produce the shared artifact that serves as source-of-truth for builders during the build phase.
---

# Scope Split

Produce the shared design artifact for a project: the scope map, design decisions, tradeoffs, and seam agreements that builders work from during the build phase. This is the source-of-truth document that everyone references.

This maps to [Technique 3: Scope splitting at the seams](https://github.com/tylerbodway/seam-up/blob/main/docs/05-techniques.md) and is a shared artifact per [Principle 2](https://github.com/tylerbodway/seam-up/blob/main/docs/04-principles.md). It's typically produced after a collaborative shaping session, capturing what the team agreed on.

## Input

The user provides:

- An engineering spec (file path, or already in context)
- Decisions from a shaping session (verbal summary, notes, or written up)
- Optionally, research pre-work or other context from the shaping process

If the user hasn't shaped yet, suggest they do that first. This skill documents decisions that have been made, not decisions that need to be made. If the user wants to explore and prepare for shaping, suggest the `research` skill instead.

## Steps

### 1. Understand what was decided

Review the engineering spec and any shaping session output. Identify:

- **Scopes**: The vertical slices the team agreed on. What does each scope cover?
- **Ownership**: Who owns each scope? (May not be assigned yet -- that's fine.)
- **Design decisions**: Technical approaches the team chose. What alternatives were considered and why were they rejected?
- **Tradeoffs**: What the team knowingly traded away. Scope that was cut, approaches that were simpler but less ideal, constraints that were accepted.
- **Seams**: Where scopes touch. What data, APIs, events, or interfaces cross the boundary between adjacent scopes?

If any of this is unclear from the input, ask the user to clarify. Don't guess at team decisions.

### 2. Define seam agreements

For each seam (boundary between adjacent scopes), define the agreement:

- **What crosses the seam**: Data shapes, API contracts, events, shared state
- **Who owns what**: Which side of the seam owns the interface? Who is the producer vs. consumer?
- **Assumptions each side can make**: What invariants hold? What can each scope rely on without checking?
- **What's explicitly out of scope**: Anything that might seem like it belongs at this seam but was decided against

Seam agreements should be concrete enough that two builders can work independently without stepping on each other, but not so detailed that they constrain implementation choices within each scope.

### 3. Write the scope split document

Ask the user where to write the output. Suggest a file name based on the project (e.g., `scope-split.md` or `scopes/<project-name>.md`).

Write the document using the template below.

## Output template

```markdown
# Scope Split: <Project Name>

> Spec: <path to the engineering spec>
> Shaped: <date or "in progress">

## Scopes

### <Scope Name>

**Owner**: <builder name or "unassigned">

<What this scope covers. Be specific about the boundaries -- what's in
and what's not.>

### <Scope Name>

**Owner**: <builder name or "unassigned">

<What this scope covers.>

## Design Decisions

### <Decision Title>

**Decided**: <what the team chose>
**Alternatives considered**: <what was rejected and why>
**Tradeoffs**: <what was knowingly traded away>

## Seams

### <Scope A> / <Scope B>

<What crosses this boundary. Data shapes, API contracts, events,
shared state. Be concrete -- define the interface, not just that
one exists.>

**Owned by**: <which scope owns the interface>

**Assumptions**:
- <What Scope A can rely on from Scope B>
- <What Scope B can rely on from Scope A>

## Open Items

<Anything that wasn't resolved during shaping but needs to be
addressed. Assign an owner if possible. Remove this section if
everything was resolved.>

- <Open item>
```

Adapt the template to fit the project. Some projects will have many scopes and seams; others might have two scopes and one seam. Scale accordingly. Remove empty sections.

## Guardrails

- This is a **shared artifact**. It represents team decisions, not one person's plan. Don't fabricate decisions that weren't made.
- If the user is working alone and splitting their own work into scopes, that's fine -- the document still serves as a reference they can share or revisit. Note that seam agreements are less critical when one person holds all scopes.
- Seam agreements should describe **what** crosses the boundary, not **how** each side implements it. The interface is shared; the implementation is each builder's domain.
- Per [Principle 5](https://github.com/tylerbodway/seam-up/blob/main/docs/04-principles.md), seam agreements update only through a proposal process once the build phase begins. This document is the baseline. Changes go through `seam-change`.
- Design decisions should include tradeoffs. A decision without a tradeoff either hasn't been fully considered or is obvious enough that it doesn't need documenting.
