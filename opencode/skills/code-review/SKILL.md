---
name: code-review
description: Review the changes since a fixed point (commit, branch, tag, or merge-base) along multiple axes — Spec, Standards, System Design, Bugs, Security, Performance, Testing, Documentation. Runs reviews in parallel subagents and builds a final report. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to "review since X".
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

All axes run as **parallel subagents** so they don't pollute each other's context. Each subagent's findings are aggregated into a priority-ranked report.

## Review philosophy

1. **Only report problems** — Any review output must only contain issues, concerns, and actionable suggestions. DO NOT mention things that are done correctly, or praise with flattery. Be helpful and matter-of-fact.
2. **Investigate, don't guess** — When uncertain whether an issue actually exists, explore further and verify assumptions. A reviewer guessing wrong provides negative value.
3. **Focus on what CI doesn't catch** — Don't bother with formatting, linting, type or test errors.
4. **Be specific** — Reference file paths and line numbers, and code excerpts when helpful to visualize issues.
5. **No repetition** — Each observations should only appear once. Combine ideas if they are directly related.

## Review process

### 1. Pin the fixed point

Whatever the user said is the fixed point — a commit SHA, branch name, tag, `main`, `HEAD~5`, etc. If they didn't specify one, ask for it.

Capture the diff command once: `git diff <fixed-point>...HEAD` (three-dot, so the comparison is against the merge-base). Also note the list of commits via `git log <fixed-point>..HEAD --oneline`.

Before going further, confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the diff is non-empty. A bad ref or empty diff should fail here — not inside two parallel subagents.

### 2. Gather spec sources

Diffs alone are not enough. Use explore subagents to read any supporting referenced material such as issues, plans, specs, docs, etc.

If nothing is found, ask the user where to find the spec. If they say there is't one, the **Spec** subagent can be skipped.

### 3. Gather coding standards sources

Use explore subagents to find anything in the repo that documents how code should be written, such as skills, `AGENTS.md`/`CLAUDE.md`, or `CONTRIBUTING.md`.

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

### 4. Spawn subagents in parallel

Use general subagents to review the code across each axis.

Every finding from every subagent must satisfy all four rules below. Anything that doesn't is dropped at aggregation, so don't waste a subagent's context on it.

- **Severity.** Each observation must categorized with exactly one:
  - **Critical:** The change is broken or unsafe as written (malfunctions, data loss, a security hole, or a core spec requirement unmet). Must fix before merge.
  - **Major:** A real defect or gap with clear, realistic impact. Should fix before merge; merging without it introduces known risk or debt.
  - **Minor:** A worthwhile improvement with low impact. Won't block; address only if time permits.
- **Validate before you report.** Don't flag what you can't verify. If an edge case matters, name the realistic scenario that triggers it. If you can't confirm a problem exists, drop it — never present an unverified hunch as a finding.
- **Be specific.** Every finding names the file and line, states concretely what's wrong, the impact it has, and a direction for fixing it. "Consider improving X" without pointing at code is not a finding — drop it.
- **Stay in scope.** Only flag what the diff introduces or touches. Don't review pre-existing unchanged code, and don't speculate about needs the spec doesn't have.

Fewer verified findings beat many vague ones. If an axis turns up nothing that clears the bar, it returns nothing.

#### Spec

Include the full diff command, commit list, and the spec context you gathered in step 2.

- Requirements the spec asked for that are missing or partial
- Behaviour in the diff that wasn't asked for (scope creep)
- Requirements that look implemented but where the implementation looks wrong

Quote the spec line for each finding. Under 400 words.

If the spec is missing, skip this subagent.

#### Standards

Include the full diff command, commit list, and any standards context you gathered in step 3.

On top of whatever the repo documents, use these basic **code smells** based on _Refactoring_ by Martin Fowler, each reads _what it is_ → _how to fix_:

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

Repo standards always trump these baselines, suppress the smell in those cases. Each smell is a labeled heuristic ("possible Feature Envy"), never a hard violation.

Report any standards violations citing the code and the rule or smell detected. Be sure to distinguish hard violations from judgement calls.

#### Bugs

- Logic errors, off-by-one mistakes, incorrect conditionals
- Missing guards, incorrect branching, unreachable code paths
- Edge cases: null/empty/undefined inputs, error conditions, race conditions
- Broken error handling that swallows failures or throws unexpectedly
- Async operations handled incorrectly (promises, error handling)
- Unintentional behavior changes

The finding contract's validate rule is especially load-bearing here — never report a suspected bug you haven't traced to a concrete code path.

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

Collect every subagent's findings. If a finding lacks a location, an impact, or verification, cut it regardless of which axis produced it. If a section lacks content, leave it out completely.

<report-example>

```md
## Code Review: (title)

### Summary

What the changes accomplish in one sentence, and the overall verdict. Under 50 words.

### Critical

1. **[Axis]:** Finding title

Quick explanation of the finding, using code references and excerpts if helpful.

2. **[Axis]:** Finding title

Quick explanation of the finding, using code references and excerpts if helpful.

### Major

### Minor

### Recommendation

**🟢 Approve** / **🔴 Request Changes** / **💬 Needs Discussion**
```

</report-example>
