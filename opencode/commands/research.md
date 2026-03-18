---
description: Research the codebase - deep exploration to understand relevant files, patterns, and architecture before planning
---

Research the codebase to understand how an idea or task maps to the existing code. This is the bridge between thinking and planning -- grounding ideas in the reality of the codebase.

**Use the Task tool with the `explore` subagent for codebase exploration.** This agent is purpose-built for searching files, reading code, and tracing patterns. Delegate exploration work to it rather than doing it manually.

Input: $ARGUMENTS

---

## Input

The user provides one or more of:

- A description of what they want to research
- A reference to a `thoughts.md` from a `/think` session
- A spec or document to investigate against the codebase
- A specific question about how the codebase handles something

If the input is unclear, ask what area of the codebase they want to understand.

---

## Steps

### 1. Understand what to research

Read any referenced artifacts (`thoughts.md`, specs, prior plans). Identify the areas that will require the most exploration. If the user has specific questions, note them.

### 2. Check for existing context

Use the Glob tool to check:

- `.docs/*/research.md` -- has this area been researched before?
- `.docs/*/thoughts.md` -- is there prior thinking to build on?
- `.docs/*/plan.md` -- has this already been planned?

If relevant artifacts exist, read them for context.

### 3. Explore the codebase

Use the Task tool with the `explore` subagent to investigate how the idea maps to the existing code. Look for:

- **Existing patterns**: How does the codebase currently handle similar problems? What conventions exist?
- **Touch points**: What parts of the codebase will this work touch? Which modules, services, or components are involved?
- **Integration surfaces**: Where does this work connect to other systems, APIs, or data stores?
- **Constraints**: What existing architecture decisions constrain the approach? Are there performance considerations, data model limitations, or technical debt that matters?

Be thorough but purposeful. The goal is to understand the landscape well enough to write an informed plan, not to audit the entire codebase.

### 4. Identify potential scope boundaries

Based on exploration, identify where the work might naturally split:

- Natural boundaries between different areas of the codebase
- Areas that could be built independently with clear interfaces between them
- Dependencies that would force sequencing

### 5. Surface open questions

List questions that need resolution before planning:

- Where multiple valid approaches exist and the tradeoffs aren't obvious
- Where a technical constraint might change the approach
- Where existing code behavior is unclear or surprising
- Where the scope might be larger or smaller than expected

Separate genuine open questions from things you can resolve with more exploration. Do the exploration first.

### 6. Draft initial design ideas

For areas you understand well, sketch initial design thinking:

- General direction, not detailed implementation
- Flag where you're uncertain or where multiple approaches seem viable
- Pay particular attention to boundaries and integration points

### 7. Write research.md

Create `.docs/<name>/research.md` using the template below.

If the folder doesn't exist yet, create it:

```bash
mkdir -p .docs/<name>
```

```markdown
# Research: <Title>

> One-line summary of what was researched and why.

## Codebase Landscape

How the idea maps to the existing code. Key modules, patterns, and conventions that are relevant. Keep it concise -- this section orients the reader, not exhaustively documents the code.

## Touch Points

Files and components that will likely be involved:

- `path/to/file` -- what it does and why it's relevant
- `path/to/other` -- what it does and why it's relevant

## Potential Scope Boundaries

Where the work might naturally split. For each potential boundary, note what would be on each side and what would cross the boundary.

## Open Questions

Questions that need resolution before or during planning.

- Question 1 -- why it matters
- Question 2 -- why it matters

## Initial Design Ideas

Rough design thinking for the areas explored. Flag uncertainty and alternatives.

## Constraints and Risks

Technical constraints, dependencies, or risks discovered during exploration. Things that should inform planning.
```

Adapt the template to fit what you found. Remove sections that aren't relevant. Add sections where the content warrants it. Keep it rough -- this is working material, not documentation.

### 8. Summarize

After writing the artifact, show:
- What was researched and what was found
- Key insights or surprises
- Open questions that need resolution
- Suggested next step: "Run `/plan` to scope the change, or `/roadmap` if this spans multiple changes."

---

## Seam Awareness (Adaptive)

If the research reveals that the work touches boundaries shared with other people or systems:

- Note scope boundaries: "This touches the API contract between X and Y."
- Identify seam risks: "Changing this data shape affects other consumers."
- Flag coordination needs in the research artifact

Don't force seam thinking. Solo work on a personal project doesn't need seam analysis. Shared codebases with multiple contributors do.

---

## Guardrails

- **Don't implement** -- Never write application code. This is research only.
- **Don't over-polish** -- Research artifacts are working material, not final documentation. Keep them rough and honest.
- **Don't prescribe solutions** -- Present what you found. Flag options and tradeoffs. The plan phase makes decisions.
- **Do use the explore subagent** -- Delegate codebase exploration to it rather than doing manual file-by-file reads
- **Do be thorough** -- Cover enough ground that `/plan` can make informed decisions
- **Do flag uncertainty** -- Use language like "likely," "appears to," and "needs verification" rather than definitive statements where appropriate
