---
name: smup-research
description: Research an engineering spec to prepare for a shaping session. Use when a builder wants to explore how a spec maps to the codebase, surface open questions, and draft initial design ideas before collaborative shaping.
---

# Research

Explore an engineering spec against the codebase to prepare personal pre-work for a collaborative shaping session. The output is a personal artifact -- rough, exploratory, and meant to give the builder a concrete starting point to bring to the team.

This maps to the preparation step of [Technique 2: Shaping with pre-work](https://github.com/tylerbodway/seam-up/blob/main/docs/05-techniques.md). The book's guidance: share this as pre-read so the shaping session focuses on refining seams and challenging assumptions, rather than starting from a blank page.

## Input

The user provides:

- An engineering spec (file path, or already in context)
- Optionally, a focus area or specific questions they want explored

If no spec is provided, ask for one.

## Steps

### 1. Read the engineering spec

Read the full spec. Understand the problem, the solution, the acceptance criteria, and any technical notes. Identify the areas that will require the most design work.

### 2. Explore the codebase

Investigate how the spec maps to the existing code. Look for:

- **Existing patterns**: How does the codebase currently handle similar problems? What conventions exist?
- **Touch points**: What parts of the codebase will this work touch? Which modules, services, or components are involved?
- **Integration surfaces**: Where does this work connect to other systems, APIs, or data stores?
- **Constraints**: What existing architecture decisions constrain the approach? Are there performance considerations, data model limitations, or technical debt that matters?

Be thorough but purposeful. The goal is to understand the landscape, not to audit the entire codebase.

### 3. Identify potential scope boundaries

Based on the spec and codebase exploration, identify where the work might naturally split into vertical slices. Look for:

- Natural ownership boundaries (frontend vs. backend, different services, different features)
- Areas that could be built independently with a clear interface between them
- Dependencies that would force sequencing between scopes

These are rough ideas, not decisions. The shaping session will refine them.

### 4. Surface open questions

List questions that need team discussion. Good questions for shaping sessions are ones where:

- The answer affects scope boundaries or seam definitions
- Multiple valid approaches exist and the team should choose together
- The builder lacks context that another team member has
- A technical constraint might change the product approach

Separate genuine open questions from things you could resolve with more codebase exploration. Do the exploration first, ask the team about what remains.

### 5. Draft initial design ideas

For the areas you understand well, sketch initial design ideas. These should be:

- **Rough**: General direction, not detailed implementation plans
- **Honest about uncertainty**: Flag where you're guessing or where multiple approaches seem viable
- **Focused on boundaries**: Pay particular attention to where different parts of the system will interact

### 6. Write the research notes

Ask the user where to write the output. Suggest a file name based on the spec (e.g., `research-<spec-name>.md`).

Write the research notes using the template below.

## Output template

```markdown
# Research: <Spec Title>

> Spec: <path to the engineering spec>

## Codebase Landscape

<How the spec maps to the existing code. Key modules, patterns, and
conventions that are relevant. Keep it concise -- this section orients
the reader, not exhaustively documents the code.>

## Potential Scope Boundaries

<Where the work might naturally split. For each potential boundary,
note what would be on each side and what would cross the seam.>

## Open Questions

<Questions that need team discussion during shaping. For each question,
note why it matters and what it affects.>

- <Question 1>
- <Question 2>

## Initial Design Ideas

<Rough design thinking for the areas you explored. Flag uncertainty
and alternatives. Use subsections for distinct areas of the spec.>

## Constraints and Risks

<Technical constraints, dependencies, or risks discovered during
exploration. Things the team should be aware of during shaping.>
```

Adapt the template to fit what you found. Remove sections that aren't relevant. Add subsections where the content warrants it.

## Guardrails

- This is a **personal artifact**. It's meant to be rough and exploratory. Don't over-polish it.
- Keep the draft rough on purpose. Per the book: "If it's too polished, you miss out on the expertise and perspective your teammates would have contributed to the initial thinking."
- Frame everything as input to the shaping session, not output from it. Use language like "potential," "might," and "initial thinking" rather than definitive statements.
- Don't prescribe scope ownership. That's a team decision made during shaping.
- Don't make boundary decisions. Identify where boundaries *might* be. The team decides where they *are*.
