---
name: code-review
description: Review the changes since a fixed point (commit, branch, tag, or merge-base) along multiple axes — Spec, Standards, System Design, Bugs, Security, Performance, Testing, Documentation. Runs reviews in parallel sub-agents and builds a final report. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to "review since X".
---

You are conducting a comprehensive code review across multiple axes of the diff between `HEAD` and a fixed point the user supplies.

- **Spec** — does the code faithfully implement the originating plan?
- **Standards** — does the code conform to this repo's standards and patterns?
- **System design** — does the code help or hurt the system's design?
- **Bugs** — is the code free of logical errors and/or behavior discrepencies?
- **Security** — is the code safe from malicious attack?
- **Performance** — is the code efficient at scale?
- **Testing** — is the code tested thoroughly and properly?
- **Documentation** — do the changes necessitate new or modified documentation?

All axes run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings.

## Process

### 1. Pin the fixed point

Whatever the user said is the fixed point — a commit SHA, branch name, tag, `main`, `HEAD~5`, etc. If they didn't specify one, ask for it.

Capture the diff command once: `git diff <fixed-point>...HEAD` (three-dot, so the comparison is against the merge-base). Also note the list of commits via `git log <fixed-point>..HEAD --oneline`.

Before going further, confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the diff is non-empty. A bad ref or empty diff should fail here — not inside two parallel sub-agents.

### 2. Gather spec sources

Diffs alone are not enough. Use explore sub-agents to read any supporting referenced material such as issues, plans, specs, docs, etc.

If nothing is found, ask the user where to find the spec. If they say there is't one, the **Spec** sub-agent can be skipped.

### 3. Gather coding standards sources

Use explore sub-agents to find anything in the repo that documents how code should be written, such as skills, `AGENTS.md`/`CLAUDE.md`, or `CONTRIBUTING.md`.

On top of whatever the repo documents, the **Standards** axis always carries the **smell baseline** below — a fixed set of code smells (based on _Refactoring_ by Fowler) that applies even when a repo documents nothing. Two rules bind it:

- **The repo overrides.** A documented repo standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation — and, like any standard here, skip anything tooling already enforces.

Each smell reads _what it is_ → _how to fix_; match it against the diff:

- **Mysterious Name** — a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code** — the same logic shape appears in more than one hunk or file in the change. → extract the shared shape, call it from both.
- **Feature Envy** — a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps** — the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession** — a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches** — the same `switch`/`if`-cascade on the same type recurs across the change. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery** — one logical change forces scattered edits across many files in the diff. → gather what changes together into one module.
- **Divergent Change** — one file or module is edited for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality** — abstraction, parameters, or hooks added for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains** — long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man** — a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest** — a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

### 4. Spawn sub-agents in parallel

Use general sub-agents to review the code across each axis:

#### Spec

Include the full diff command and commit list and the spec context you gathered in step 2.

- Requirements the spec asked for that are missing or partial
- Behaviour in the diff that wasn't asked for (scope creep)
- Requirements that look implemented but where the implementation looks wrong

Quote the spec line for each finding. Under 400 words.

If the spec is missing, skip this sub-agent.

#### Standards

Include the full diff command and commit list and any standards context you gathered in step 3.

Report against each place the diff violates a standard citing the code and the rule or smell detected. Distinguish hard violations from judgement calls — documented-standard breaches can be hard, but baseline smells are always judgement calls, and a documented repo standard overrides the baseline. Skip anything tooling enforces. Under 400 words.

#### Bugs

- Logic errors, off-by-one mistakes, incorrect conditionals
- Missing guards, incorrect branching, unreachable code paths
- Edge cases: null/empty/undefined inputs, error conditions, race conditions
- Broken error handling that swallows failures or throws unexpectedly
- Async operations handled incorrectly (promises, error handling)
- Unintentional behavior changes

**Flag, validate, describe.** When determining whether to report a bug:

- Don't flag something as a bug if you're unsure. Investigate first.
- Don't invent hypothetical problems. If an edge case matters, explain the realistic scenario where it breaks.
- If you still can't verify, say "I'm not sure about X" rather than flagging it as a definite issue.

#### Security

- Injection, XSS, CSRF vulnerabilities
- User input not validated or sanitized
- Authentication and authorization handled incorrectly
- Secrets or sensitive data exposed (API keys, passwords, tokens)
- Unsafe operations or deprecated APIs
- Timing attacks or information disclosure risks

#### Performance

- O(n²) on unbounded data, N+1 queries, blocking I/O on hot paths
- Missing resource cleanup (connections, file handles, timers)
- Unnecessary re-renders or re-computations

Only flag in the final report if obviously problematic.

#### System Design

- Is the solution as simple as possible while meeting requirements?
- Unnecessary complexity or over-engineering?
- Violations of YAGNI?
- Do the changes warrant rethinking abstractions?

#### Testing

- Does the change include tests for new functionality?
- Are test cases comprehensive (happy path + edge cases + error cases)?
- Are there obvious untested scenarios?
- Do tests actually validate intended domain behavior?
- Do tests avoid focusing on implementation?
- Do tests avoid validating third-party behavior (framework, libraries, etc.)?

#### Documentation

- Is complex logic or business rules explained?
- Are necessary documentation updates included (README, CONTRIBUTING, AGENT.md, CLAUDE.md, etc.)?
- Are API changes documented?
- Are breaking changes highlighted?

### 5. Aggregate final report

Present the findings in a final report sectioned by axis either verbatim or lightly cleaned. **Do not** merge or re-rank findings — they are deliberately separate.

Always include code examples and file locations when relevant.
