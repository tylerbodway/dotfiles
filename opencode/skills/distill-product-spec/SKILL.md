---
name: distill-product-spec
description: Distill a product spec from Notion into an engineering-focused spec file. Use when the user wants to extract, translate, or distill a product specification from Notion into a concise engineering planning document.
---

# Distill Product Spec

Fetch a product spec from Notion and translate it into a lean, engineering-focused
specification. Strips research, appetite, no-go's, rabbit holes, rollout plans,
success metrics, meeting notes, and other non-engineering context. Focuses on what
engineers need: the problem, the solution, edge cases, and acceptance criteria.

## Input

The user provides **one** of:

- A Notion page URL (e.g., `https://www.notion.so/...`)
- Search keywords to find the spec (e.g., "bulk enrollment redesign")

If neither is provided, ask:

> What product spec should I find? Provide a Notion URL or search keywords.

## Steps

### 1. Fetch the spec from Notion

Use the **Task tool** with `subagent_type: "knowledge-base"` to retrieve the
full spec content. Pass along the user's URL or keywords and ask the agent to
return the **complete, unsummarized content** organized by section headings.

If the agent finds multiple matches, present the options to the user.
If it finds nothing, suggest refining the search terms.

### 2. Choose output location

Ask the user where to write the distilled spec:

- **`spec.md` in the current directory** (default)
- **Custom file path**

### 3. Distill the spec

Transform the raw product spec into an engineering-focused document. Apply the
template structure below.

**Include** (if present in the source):

- Problem statement — what user/business problem is being solved
- Solution description — what the product change looks like, how it works
- User-facing behavior — what users see, do, and experience
- Edge cases and constraints — boundary conditions, limitations
- Acceptance criteria — concrete conditions for "done"
- Data model or schema changes — new fields, tables, relationships
- API changes — new or modified endpoints, payloads
- UI/UX details — screens, flows, states, interactions
- Permissions and access control — who can do what
- Migration or backward compatibility notes — data migration, feature flags

**Exclude** (even if present in the source):

- Research and discovery notes
- Appetite, time budgets, or cycle framing
- No-go's and rabbit holes (Shape Up artifacts)
- Rollout plans and phased launches
- Success metrics and KPIs
- Meeting notes and discussion threads
- Stakeholder signoff or approval history
- Marketing and communication plans
- Competitive analysis

**Judgment calls**: If a section doesn't fit neatly into include/exclude, ask:
"Would an engineer need this to build the feature?" If yes, include it. If it's
only useful for product planning or business context, exclude it.

### 4. Write the file

Write the distilled spec using the template below. After writing, report:

- The file path
- A brief summary of what was included
- Any sections from the source spec that were excluded and might be worth reviewing

## Output Template

```markdown
# <Spec Title>

> Source: <Notion page title and URL if available>

## Problem

<What user or business problem does this solve? Why does it matter?>

## Solution

<High-level description of the product change. What does it do?>

## Detailed Behavior

<How the solution works from the user's perspective. Describe flows, screens,
interactions, and states. Use subsections as needed.>

## Edge Cases

<Boundary conditions, unusual inputs, error states, and how to handle them.>

- <Edge case 1>
- <Edge case 2>

## Acceptance Criteria

<Concrete, testable conditions that must be true for this to be complete.>

- [ ] <Criterion 1>
- [ ] <Criterion 2>

## Technical Notes

<Data model changes, API changes, permissions, migrations, or other
implementation-relevant details from the spec. Omit this section if the
product spec contains no technical details.>
```

Adapt the template to fit the content. Not every section will apply to every spec.
Add subsections under "Detailed Behavior" or "Technical Notes" as needed. Remove
empty sections rather than leaving placeholders.

## Guardrails

- Do NOT fabricate requirements. Only include what is in the source spec.
- Do NOT editorialize or add engineering recommendations — this is a translation, not a design doc.
- Preserve the spec's intent. When rephrasing for clarity, do not change the meaning.
- If the source spec is ambiguous, note the ambiguity rather than guessing.
- Keep the tone neutral and direct.
