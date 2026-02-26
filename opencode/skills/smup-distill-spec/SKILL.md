---
name: smup-distill-spec
description: Distill a product spec into an engineering spec. Use when a builder has a product spec and needs to translate it into a focused engineering document with shared and personal layer separation.
---

# Distill Spec

Translate a product spec into a lean engineering spec. The product spec comes from the product team and covers the full problem and solution space. The engineering spec strips away non-engineering context and focuses on what builders need to understand the problem, design a solution, and deliver working software.

This is the entry point to the [Seam Up](https://github.com/tylerbodway/seam-up/blob/main/docs/01-thesis.md) workflow. The engineering spec becomes the shared foundation that all builders work from. It maps to [Technique 1: Layered artifact production](https://github.com/tylerbodway/seam-up/blob/main/docs/05-techniques.md).

## Input

The user provides a product spec. This could be:

- Pasted text
- A file path
- A URL

If no spec is provided, ask for one.

## Steps

### 1. Read and understand the product spec

Read the full product spec. Identify its structure and what it covers. Don't start distilling until you've read the whole thing -- product specs often have context scattered across sections that only makes sense as a whole.

### 2. Ask where to write the output

Ask the user where to write the engineering spec. Suggest `spec.md` in the current directory as a default, but accept any file path.

### 3. Distill the spec

Transform the product spec into an engineering-focused document. The goal is translation, not editorializing. Preserve the spec's intent. When rephrasing for clarity, don't change the meaning.

**Include** (if present in the source):

- Problem statement -- what user or business problem is being solved
- Solution description -- what the change looks like, how it works
- User-facing behavior -- what users see, do, and experience
- Edge cases and constraints -- boundary conditions, limitations, error states
- Acceptance criteria -- concrete conditions for "done"
- Data model or schema changes -- new fields, tables, relationships
- API changes -- new or modified endpoints, payloads
- UI/UX details -- screens, flows, states, interactions
- Permissions and access control -- who can do what
- Migration or backward compatibility notes -- data migration, feature flags

**Exclude** (even if present in the source):

- Research and discovery notes
- Appetite, time budgets, or cycle framing
- Rollout plans and phased launches
- Success metrics and KPIs
- Meeting notes and discussion threads
- Stakeholder signoff or approval history
- Marketing and communication plans
- Competitive analysis

**Judgment calls**: If a section doesn't fit neatly into include or exclude, ask: "Would a builder need this to do their work?" If yes, include it. If it's only useful for product planning or business context, exclude it.

### 4. Apply layer separation

Before writing, review the distilled content through the lens of [shared and personal artifacts](https://github.com/tylerbodway/seam-up/blob/main/docs/04-principles.md):

- **Shared layer**: Content that all builders need to understand. The problem, the solution, acceptance criteria, and any constraints that affect scope boundaries. This is the core of the engineering spec.
- **Personal layer**: Content that an individual builder would use for their own planning. Implementation ideas, technical approaches, task breakdowns. If the product spec contains these, note them in a separate section rather than weaving them into the shared content.

The engineering spec is a shared artifact. Its primary audience is all builders on the project. It should give everyone enough context to shape scopes and define seams, without prescribing how any individual builder approaches their work.

### 5. Write the spec

Write the engineering spec using the template below. After writing, report:

- The file path
- A brief summary of what was included
- Any sections from the source that were excluded and might be worth the user reviewing

## Output template

```markdown
# <Spec Title>

> Source: <where the product spec came from, if known>

## Problem

<What user or business problem does this solve? Why does it matter?>

## Solution

<High-level description of the change. What does it do?>

## Detailed Behavior

<How the solution works from the user's perspective. Flows, screens,
interactions, states. Use subsections as needed.>

## Edge Cases

<Boundary conditions, unusual inputs, error states, and how to handle them.>

## Acceptance Criteria

<Concrete, testable conditions that must be true for this to be complete.>

- [ ] <Criterion>

## Technical Notes

<Data model changes, API changes, permissions, migrations, or other
implementation-relevant details from the spec. Omit this section if the
product spec contains no technical details.>

## Notes for Builders

<Anything from the product spec that's relevant but doesn't fit the above.
Implementation ideas, open questions from the product team, known risks.
Omit this section if there's nothing to add.>
```

Adapt the template to fit the content. Not every section will apply to every spec. Add subsections where needed. Remove empty sections rather than leaving placeholders.

## Guardrails

- Do NOT fabricate requirements. Only include what is in the source spec.
- Do NOT add engineering recommendations. This is a translation, not a design document.
- Preserve the spec's intent. When rephrasing for clarity, don't change the meaning.
- If the source spec is ambiguous, note the ambiguity rather than guessing.
- Keep the tone neutral and direct.
