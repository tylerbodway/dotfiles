# Skill mechanics

The skill-specific branch of [`writing-for-agents`](SKILL.md): what changes when the document is a skill — where it lives, frontmatter, and the invocation choice. Everything else about writing it is the universal reference in `SKILL.md`.

OpenCode loads skills from `~/.config/opencode/skills` (global) and `.opencode/skills` (project, searched up to the project root). The **ID** comes from the path, not the frontmatter `name`: `skills/writing-for-agents/SKILL.md` is ID `writing-for-agents`, and that ID is what the `skill` tool takes and what `@skill-id` mentions load. Use lowercase kebab-case for the directory name. Supporting files live beside `SKILL.md` and are referenced by relative path; they are only read when the skill directs the agent to read them — so every reference into them is a context pointer under the `SKILL.md` rules.

## Frontmatter

- `name`: display label only. The path decides the ID.
- `description`: what the model is shown. Omit it and the skill is never advertised.
- `metadata.opencode/autoinvoke: false` (or `disable-model-invocation: true`): strike the skill from the model's available list. When both are set, `opencode/autoinvoke` wins.

## Invocation

Three surfaces, trading the two loads:

- A **default skill** keeps a `description`, so the agent fires it autonomously and other skills reach it through the `skill` tool. You can still load it by hand with `@skill-id`: model invocation always _includes_ user reach; a description only ever adds agent discovery, never removes the human's. The description is the skill's top-level context pointer, forced to stay loaded at all times: permanent context load in exchange for discoverability. A default skill whose content is all reference is also one home for shared reference: any other advertised skill can invoke it, so reference needed by several skills lives in one place. Mechanics: omit `metadata.opencode/autoinvoke`, and write a model-facing description carrying the trigger branches (the pointer-writing rules in `SKILL.md` apply in full).
- A **hidden skill** sets `metadata.opencode/autoinvoke: false`: only the human pulling it in with `@skill-id` loads it, and no other skill can reach it either. Zero context load, but it spends cognitive load: you are the index that must remember it exists.
- A **command** (`opencode/commands/<id>.md`) is a prompt template keyed to a human action. Zero context load, zero model reach, and outside the skill system entirely: no other skill can reach it, and it carries no description to maintain.

Pick a default skill when the agent must reach the material on its own, or another skill must. If it only ever fires by hand, make it a command and pay no context load. Reach for a hidden skill when the human wants the full body available on demand but the agent should never fire it unprompted.

Shared reference that two hidden skills both need can live in neither: with nothing advertised, neither can reach the other. Push it to a plain file outside the skill system or a default skill's body — either is external reference any skill can point at.

## Splitting by invocation

Split off a default skill when a distinct leading word should trigger it on its own (a trigger word you actually use in your prompts), or another skill must reach it. You pay context load for the new always-loaded description, so that independent reach has to be worth it.

## Portability

`AGENTS.md` is the cross-agent instruction file — OpenCode, pi, and most agents that follow the spec read it, and newer Claude Code versions read it too when no `CLAUDE.md` is present. Decision rule: prefer `AGENTS.md` for new projects and new rules; use `CLAUDE.md` where one already exists. Keep the instruction writing agent-neutral (the levers in `SKILL.md` hold everywhere); only the invocation mechanics differ per tool.
