---
name: skill-creator
description: Guide for creating effective OpenCode skills. Use when users want to create a new skill or update an existing skill that extends agent capabilities with specialized knowledge, workflows, or tool integrations.
---

# Skill Creator

Create effective OpenCode skills that extend agent capabilities.

## What Skills Provide

1. **Specialized workflows** - Multi-step procedures for specific domains
2. **Tool integrations** - Instructions for working with specific file formats or APIs
3. **Domain expertise** - Company-specific knowledge, schemas, business logic
4. **Bundled resources** - Scripts, references, and assets for complex tasks

## Core Principles

### Be Concise

The context window is shared by system prompts, conversation history, and all skills. Only add context the agent doesn't already have. Prefer concise examples over verbose explanations.

### Match Specificity to Task Fragility

- **High freedom** (text instructions): Multiple valid approaches, context-dependent decisions
- **Medium freedom** (pseudocode/parameterized scripts): Preferred patterns with acceptable variation
- **Low freedom** (specific scripts): Fragile operations, consistency critical, exact sequence required

## Skill Structure

### Directory Layout

```
skill-name/
├── SKILL.md (required)
└── Optional resources:
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── references/       - Documentation loaded into context as needed
    └── assets/           - Files used in output (templates, icons, etc.)
```

### File Locations

OpenCode searches these paths (project-local paths walk up to git root):

| Location                  | Path                                        |
| ------------------------- | ------------------------------------------- |
| Project config            | `.opencode/skills/<name>/SKILL.md`          |
| Global config             | `~/.config/opencode/skills/<name>/SKILL.md` |
| Project Claude-compatible | `.claude/skills/<name>/SKILL.md`            |
| Global Claude-compatible  | `~/.claude/skills/<name>/SKILL.md`          |

### SKILL.md Format

```markdown
---
name: my-skill-name
description: Clear description of what this skill does and when to use it
---

# Skill Title

Instructions and guidance for using the skill.
```

### Frontmatter Fields

| Field           | Required | Rules                                                                                 |
| --------------- | -------- | ------------------------------------------------------------------------------------- |
| `name`          | Yes      | 1-64 chars, lowercase alphanumeric, single hyphens allowed, must match directory name |
| `description`   | Yes      | 1-1024 chars, explain what it does AND when to use it                                 |
| `license`       | No       | License identifier                                                                    |
| `compatibility` | No       | Tool compatibility                                                                    |
| `metadata`      | No       | String-to-string map of custom fields                                                 |

### Name Validation

Names must:

- Be 1-64 characters
- Use only lowercase letters, numbers, and single hyphens
- Not start or end with `-`
- Not contain consecutive `--`
- Match the containing directory name

Regex: `^[a-z0-9]+(-[a-z0-9]+)*$`

## Bundled Resources

### scripts/

Executable code for deterministic reliability or frequently rewritten tasks.

- **When to include**: Same code rewritten repeatedly, deterministic reliability needed
- **Benefits**: Token efficient, deterministic, can execute without loading into context

### references/

Documentation loaded into context as needed.

- **When to include**: Documentation the agent should reference while working
- **Examples**: Database schemas, API docs, domain knowledge, policies
- **Best practice**: For files >10k words, include grep patterns in SKILL.md
- **Avoid duplication**: Information lives in either SKILL.md OR references, not both

### assets/

Files used in output, not loaded into context.

- **When to include**: Files used in final output
- **Examples**: Templates, images, boilerplate code, fonts

### What NOT to Include

Do not create extraneous files:

- README.md, INSTALLATION_GUIDE.md, CHANGELOG.md, etc.
- User-facing documentation
- Setup and testing procedures

## Progressive Disclosure

Skills use three-level loading:

1. **Metadata** (name + description) - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<500 lines recommended)
3. **Bundled resources** - As needed by agent

### Patterns

**Pattern 1: High-level guide with references**

```markdown
# PDF Processing

## Quick start

[code example]

## Advanced features

- **Form filling**: See [references/forms.md](references/forms.md)
- **API reference**: See [references/api.md](references/api.md)
```

**Pattern 2: Domain-specific organization**

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── references/
    ├── finance.md
    ├── sales.md
    └── product.md
```

**Pattern 3: Conditional details**

```markdown
# DOCX Processing

## Creating documents

Use docx-js. See [references/docx-js.md](references/docx-js.md).

## Advanced

**For tracked changes**: See [references/redlining.md](references/redlining.md)
```

## Skill Creation Process

### Step 1: Understand with Examples

Ask clarifying questions:

- "What functionality should this skill support?"
- "Can you give examples of how it would be used?"
- "What would a user say that should trigger this skill?"

### Step 2: Plan Resources

For each example, identify:

1. How to execute from scratch
2. What scripts, references, and assets would help with repeated execution

### Step 3: Create the Skill

1. Create the directory: `.opencode/skills/<skill-name>/`
2. Create `SKILL.md` with proper frontmatter
3. Add any bundled resources (scripts/, references/, assets/)

```bash
# Example
mkdir -p .opencode/skills/my-new-skill
touch .opencode/skills/my-new-skill/SKILL.md
```

### Step 4: Write SKILL.md

**Frontmatter tips:**

- `description` is the primary trigger mechanism
- Include both what the skill does AND when to use it
- All "when to use" info goes in description, not body (body loads after triggering)

**Body tips:**

- Use imperative form
- Keep under 500 lines
- Split to references/ if approaching limit
- Always reference bundled resources and explain when to use them

### Step 5: Test Scripts

Run any added scripts to verify they work. For similar scripts, test a representative sample.

### Step 6: Validate

Verify:

- [ ] `SKILL.md` is spelled in all caps
- [ ] Frontmatter includes `name` and `description`
- [ ] Name matches directory name
- [ ] Name follows validation rules (lowercase, hyphens, no consecutive dashes)
- [ ] Description is 1-1024 characters
- [ ] Skill name is unique across all locations

### Step 7: Iterate

After real usage:

1. Notice struggles or inefficiencies
2. Identify needed updates
3. Implement changes and test again

## Example Skill

`.opencode/skills/git-release/SKILL.md`:

```markdown
---
name: git-release
description: Create consistent releases and changelogs. Use when preparing a tagged release from merged PRs.
---

## What I do

- Draft release notes from merged PRs
- Propose a version bump
- Provide a copy-pasteable `gh release create` command

## Instructions

1. Get merged PRs since last tag: `git log $(git describe --tags --abbrev=0)..HEAD --oneline`
2. Analyze changes to determine version bump (major/minor/patch)
3. Format release notes from PR titles and descriptions
4. Output the `gh release create` command
```
