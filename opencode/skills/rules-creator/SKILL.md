---
name: rules-creator
description: Create or improve AGENTS.md/CLAUDE.md files for AI coding agents. Use when setting up a new project for AI assistance, auditing an existing rules file, or when the user asks about best practices for agent instructions.
---

# Rules File Creator

Create effective `AGENTS.md` (or `CLAUDE.md`) files that maximize AI agent performance.

## Core Insight

LLMs are stateless. They know nothing about your codebase at session start. The rules file is the only content guaranteed in every conversation—making it high-leverage but also high-risk if poorly written.

## The Three Pillars

A good rules file answers:

| Pillar   | Purpose                                                    |
| -------- | ---------------------------------------------------------- |
| **WHAT** | Tech stack, project structure, codebase map                |
| **WHY**  | Purpose of the project and its components                  |
| **HOW**  | How to work on the project (tools, commands, verification) |

## Guiding Principles

### Less Is More

- LLMs reliably follow ~150-200 instructions
- Agent harnesses already consume ~50 instructions
- Each unnecessary instruction degrades performance _uniformly_ across all instructions
- Target: <300 lines, ideally <100

### Universal Applicability

- Only include what applies to _every_ session
- Task-specific content dilutes relevance and may be ignored
- Agent harnesses wrap rules with "may or may not be relevant"—bloated files get skipped

### Progressive Disclosure

Don't dump everything in the file. Maintain separate docs and point to them:

```
agent_docs/
├── building.md
├── testing.md
├── code_conventions.md
├── architecture.md
└── database_schema.md
```

Then in your rules file:

```markdown
## Additional Context

When working on specific areas, read the relevant guide:

- Building: `agent_docs/building.md`
- Testing: `agent_docs/testing.md`
- Architecture: `agent_docs/architecture.md`
```

### Pointers Over Copies

- Use `file:line` references instead of embedding code
- Code snippets become stale; references stay current
- Example: "See the validation logic in `app/models/user.rb:42-58`"

### Don't Replicate Tooling

- Never use LLMs as linters—they're slow and expensive
- Reference your linter/formatter config instead
- Example: "Format with `npm run format` before committing"

### Craft Deliberately

- Never auto-generate with `/init` or similar
- This is your highest leverage point
- Every line affects all downstream work: research, plans, implementation

## Instructions

### Creating a New Rules File

1. **Assess the project**:
   - Identify the tech stack and key dependencies
   - Understand the project structure (monorepo? microservices?)
   - Find existing build/test/lint commands

2. **Draft the WHAT section**:
   - Brief repository overview (1-2 sentences)
   - Project structure with directories and their purposes
   - Key technologies and frameworks

3. **Draft the WHY section** (often implicit):
   - What problem does this project solve?
   - What are the main components and their roles?

4. **Draft the HOW section**:
   - Build commands (keep concise—just the essentials)
   - Test commands
   - Lint/format commands
   - Any project-specific workflows

5. **Add progressive disclosure pointers**:
   - List any existing documentation the agent should reference
   - Create `agent_docs/` if needed for complex topics

6. **Review for bloat**:
   - Remove anything not universally applicable
   - Convert code snippets to file references
   - Ensure <300 lines

### Auditing an Existing Rules File

1. **Count instructions**: Estimate the number of discrete directives
2. **Check universality**: Flag anything task-specific
3. **Identify code snippets**: Convert to file references
4. **Look for linter duplication**: Remove style rules handled by tools
5. **Measure length**: Target <300 lines
6. **Suggest progressive disclosure**: Move specialized content to separate docs

## Template

```markdown
# AGENTS.md

Brief description of the repository and its purpose.

## Project Structure

\`\`\`
project/
├── src/ # Application source code
├── tests/ # Test suite
└── docs/ # Documentation
\`\`\`

## Tech Stack

- Language: [e.g., TypeScript 5.x]
- Framework: [e.g., Next.js 14]
- Database: [e.g., PostgreSQL 16]

## Commands

| Task   | Command          |
| ------ | ---------------- |
| Build  | `npm run build`  |
| Test   | `npm run test`   |
| Lint   | `npm run lint`   |
| Format | `npm run format` |

## Code Style

[Reference your linter/formatter config, don't enumerate rules]

Formatting is handled by Prettier (`.prettierrc`). Linting by ESLint (`.eslintrc`).
Run `npm run format` before committing.

## Additional Context

For detailed guidance on specific areas:

- Architecture decisions: `docs/architecture.md`
- Database schema: `docs/schema.md`
- API conventions: `docs/api.md`

## Important Notes

[Only include truly universal gotchas—things that affect every session]

- Environment variables are in `.env.example`
- Never commit secrets
- Default branch is `main`
```

## Anti-Patterns to Avoid

| Anti-Pattern                 | Why It's Bad                                    | Instead                          |
| ---------------------------- | ----------------------------------------------- | -------------------------------- |
| Exhaustive command lists     | Bloats context, rarely all relevant             | Essential commands only          |
| Inline code style rules      | Duplicates linter, wastes instructions          | Reference config files           |
| Task-specific instructions   | Dilutes relevance, may cause file to be ignored | Move to separate docs            |
| Auto-generated content       | Generic, misses project nuance                  | Hand-craft deliberately          |
| Long code examples           | Becomes stale, bloats context                   | Use `file:line` references       |
| "Always do X" for edge cases | Wastes instruction budget on rare scenarios     | Document in task-specific guides |

## Output

When creating or auditing a rules file:

1. Present the proposed content in a code block
2. Note the line count
3. Highlight any sections that could be moved to progressive disclosure
4. Flag any remaining anti-patterns for user decision
