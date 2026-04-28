# Prompt Templates

Load only the template you need. Do not load all at once.

| Template                                                  | Best for                                         |
| --------------------------------------------------------- | ------------------------------------------------ |
| [A — RTF](#template-a--rtf)                               | Simple one-shot tasks                            |
| [B — CO-STAR](#template-b--co-star)                       | Professional documents, business writing         |
| [C — RISEN](#template-c--risen)                           | Multi-step projects with clear sequence          |
| [D — CRISPE](#template-d--crispe)                         | Creative work, brand voice                       |
| [E — Chain of Thought](#template-e--chain-of-thought)     | Logic/debug on Tier 2 models only                |
| [F — Few-Shot](#template-f--few-shot)                     | Format replication                               |
| [G — File-Scope](#template-g--file-scope)                 | Cursor/Windsurf/Copilot inline edits             |
| [H — Agentic Task Brief](#template-h--agentic-task-brief) | Claude Code/Cline/Devin/agentic coding           |
| [I — Memory-Loaded](#template-i--memory-loaded)           | Prompts that carry session context forward       |
| [L — Prompt Decompiler](#template-l--prompt-decompiler)   | Break down/adapt/simplify/split existing prompts |

---

## Template A — RTF

_Role, Task, Format. Fast one-shot when the request is clear._

```
Role: [One sentence defining who the AI is]
Task: [Precise verb + what to produce]
Format: [Exact format and length]
```

Example:

```
Role: You are a senior technical writer.
Task: Write a one-paragraph description of what a REST API is.
Format: Plain prose, 3 sentences max, no jargon, for a non-technical audience.
```

---

## Template B — CO-STAR

_Context, Objective, Style, Tone, Audience, Response. Professional writing where context control matters._

```
Context: [Background the AI needs]
Objective: [Exact goal — what success looks like]
Style: [formal / conversational / technical / narrative]
Tone: [authoritative / empathetic / urgent / neutral]
Audience: [Who reads this — knowledge level and expectations]
Response: [Format, length, structure]
```

---

## Template C — RISEN

_Role, Instructions, Steps, End Goal, Narrowing. Multi-step projects._

```
Role: [Expert identity]
Instructions: [Overall task in plain terms]
Steps:
  1. [First action]
  2. [Second action]
  3. [Continue]
End Goal: [What the final output must achieve]
Narrowing: [Constraints, scope limits, what to exclude]
```

---

## Template D — CRISPE

_Capacity, Role, Insight, Statement, Personality, Experiment. Creative work where voice and iteration matter._

```
Capacity: [Capability or expertise needed]
Role: [Specific persona]
Insight: [Background insight that shapes the response]
Statement: [Core task or question]
Personality: [Tone — sharp / dry / warm / authoritative]
Experiment: [Variants to explore]
```

---

## Template E — Chain of Thought

_Logic, math, debugging, multi-factor analysis on Tier 2 models. Do NOT use for Tier 1 reasoning-native models._

```
[Task statement]

Before answering, think through this carefully:
<thinking>
1. What is the actual problem?
2. What constraints must the solution respect?
3. What are the possible approaches?
4. Which is best and why?
</thinking>

Give your final answer in <answer> tags only.
```

When NOT to use: simple tasks, creative tasks (kills voice), any reasoning-native model.

---

## Template F — Few-Shot

_When format is easier to show than describe._

```
[Task instruction]

Examples of the exact format needed:

<examples>
  <example>
    <input>[example input 1]</input>
    <output>[example output 1]</output>
  </example>
  <example>
    <input>[example input 2]</input>
    <output>[example output 2]</output>
  </example>
</examples>

Now apply this exact pattern to: [actual input]
```

Rules: 2–5 examples. Include edge cases. Switch to few-shot when you've re-prompted twice for the same formatting issue.

---

## Template G — File-Scope

_Cursor, Windsurf, Copilot, any inline code-editing AI. Prevents editing the wrong file or breaking existing logic._

```
File: [exact/path/to/file.ext]
Function/Component: [exact name]

Current Behavior:
[What this code does right now]

Desired Change:
[What it should do after the edit]

Scope:
Only modify [function / component / section].
Do NOT touch: [list everything to leave unchanged]

Constraints:
- Language/framework: [version]
- Do not add dependencies not in [package.json / Gemfile / requirements.txt]
- Preserve existing [type signatures / API contracts / variable names]

Done When:
[Exact condition that confirms the change worked]
```

---

## Template H — Agentic Task Brief

_Claude Code, Cline, Cursor agent mode, Devin, Aider, OpenCode — any AI that takes autonomous actions. Stop conditions are not optional._

```
## Objective
[What needs to be built or fixed — one sentence. Add WHY if it affects approach.]

## Starting State
[What exists now — relevant files, current behavior, stack already in place, what was tried and failed]

## Target State
[What done looks like — specific files, behavior, tests passing. Binary where possible.]

## Scope
- Work only in: [specific files and directories]
- Do NOT touch: [.env, lockfiles, configs, anything outside scope]

## Constraints
- [Stack/version, naming conventions, no new deps without asking]
- Only make changes directly requested. Do not add features, abstractions, or files beyond what was asked.

## Acceptance Criteria
- [ ] [Binary check 1]
- [ ] [Binary check 2]
- [ ] [Binary check 3]

## Stop Conditions
Pause and ask before:
- Deleting any file
- Adding any dependency
- Modifying database schema or migrations
- Touching anything outside Scope
- Resolving an error after 2 failed attempts
- Choosing between two valid implementation paths that affect architecture

## Progress
After each completed step: ✅ [what was done] — [file(s) affected]
At the end: full summary of every file changed.
```

**Thinking depth — add only when needed:**

- Hard multi-step task: `"Think carefully before starting."`
- Simple targeted change: `"This is a scoped change. Prioritize responding quickly."`
- Default: say nothing — adaptive thinking calibrates itself.

**For tools with sessions (Claude Code, Cline) — add when relevant:**

```
## Session Strategy
- New session — unrelated to prior context
- Continue — prior context still needed
- Subagent — spin off for [file-heavy research / verification] to keep main context clean
- Compact first — run /compact [focus on X] then begin
```

---

## Template I — Memory-Loaded

_Prompts that carry session context forward. Place the memory block in the first 30% so it survives attention decay._

```
## Context (carry forward)
- Stack and tool decisions: [list]
- Architecture choices locked: [list]
- Constraints from prior turns: [list]
- What was tried and failed: [list]

## Task
[Precise verb + what to produce]

## Output
[Format, length, structure]

## Constraints
[Must / must-not]
```

---

## Template L — Prompt Decompiler

_User pastes an existing prompt and wants it analyzed, adapted, simplified, or split. This is analysis, not building from scratch._

Detect which sub-task:

- **Break down** — explain what each part does
- **Adapt** — rewrite for a different tool, preserve intent
- **Simplify** — remove redundancy, tighten without losing meaning
- **Split** — divide a complex one-shot prompt into a clean sequence

For Adapt, ask: "Which tool is the original for, and which tool are you adapting it for?"

**Break down output:**

```
Original prompt: [paste]

Structure analysis:
- Role/Identity: [what role and why]
- Task: [what action is requested]
- Constraints: [what limits are set]
- Format: [what output shape is expected]
- Weaknesses: [what's missing or could cause wrong output]

Recommended fix: [rewritten version with gaps filled]
```

**Adapt output:**

```
Original ([source tool]): [original prompt]

Adapted for [target tool]:
[rewritten prompt using target tool's syntax and best practices]

Key changes:
- [change 1 and why]
- [change 2 and why]
```

**Split output:**

```
Original prompt: [paste]

This prompt is doing [N] things. Split into [N] sequential prompts:

Prompt 1 — [what it handles]:
[prompt block]

Prompt 2 — [what it handles]:
[prompt block]

Run in order. Each output feeds the next.
```
