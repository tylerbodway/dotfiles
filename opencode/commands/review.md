---
description: Review code changes (diff, commit, branch, or PR)
agent: plan
---

# Code Review

You are conducting a comprehensive code review.

## Process

### 1. Determine what to review

**Review context:** $1

1. **No arguments (default)**: Review all uncommitted changes
2. **Commit hash** (40-char SHA or short hash): Review that specific commit
3. **Branch name**: Review the specified branch against its base
4. **PR URL or number** (contains "github.com", "pull", "pr", or looks like a PR number): Review the pull request against its base

**Additional reviewer concerns**: $2

If any, be sure to address these concerns within relevant report sections.

### 2. Checkout changes

If reviewing a commit, branch, or PR, you MUST git checkout the relevant changes before reading and comparing local files.

If there is a dirty git status, STOP, and ask the user how they'd like to handle their changes.

### 3. Gather context

**Diffs alone are not enough.** Use explore subagents to:

- Read the full files being modified to understand surrounding context
- Read any referenced planning materials such as plan docs, issues or tasks, etc.
- Read full files to understand existing patterns, control flow, and error handling
- For PRs, read any existing reviews and discussions

### 4. Conduct the review

Only focus on the relevant changes. Do not review pre-existing code that was not modified.

Use plan subagents to analyze the changes across these dimensions:

#### Bugs and correctness (primary focus)

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

#### Pattern and style matching

- Does the code follow patterns established in AGENTS.md/CLAUDE.md?
- Is it consistent with the existing codebase style?
- Are there deviations from project conventions that need addressing?
- Are naming conventions consistent with the project?

**Don't be a zealot about style.** When checking against conventions:

- Verify the code is _actually_ in violation. Don't complain about else statements if early returns are already used correctly.
- Some "violations" are acceptable when they're the simplest option.
- Excessive nesting is a legitimate concern regardless of other style choices.
- Don't flag style preferences as issues unless they clearly violate established project conventions.

#### System design

- Is the solution as simple as possible while meeting requirements?
- Unnecessary complexity or over-engineering?
- Violations of YAGNI?
- Do the changes warrant rethinking abstractions?

#### Performance

- O(n²) on unbounded data, N+1 queries, blocking I/O on hot paths
- Missing resource cleanup (connections, file handles, timers)
- Unnecessary re-renders or re-computations

Only flag in the final report if obviously problematic.

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

### 5. Generate a report

If there is no meaningful feedback in a section, DO NOT include it.

When referring to code, be specific, use file names and line numbers, example:

> app/javascript/utils/add.ts:1-3

```ts
export function add(a: number, b: number): number {
  return a + b;
}
```

#### Report template

```md
# Review: <source>

Brief description

- **Risk Level**: ✅ Low / 🚧 Medium / 🚨 High
- **Confidence**: How confident are you in the safety of these changes?
- **Recommendation** (with brief reasoning):
  - **👍 Approve**: Safe to merge with no blocking issues
  - **👎 Request Changes**: Blocking issues must be addressed
  - **💬 Needs Discussion**: Architectural or design questions to resolve

## Feedback

### Strengths

- What is done well
- Good practices demonstrated
- Effective solutions or approaches

### Critical concerns

- Security vulnerabilities or exploits
- Breaking changes or bugs that will cause failures
- Data loss or corruption risks
- Explain the impact and provide specific fix recommendations

### Major concerns

- Significant code quality or design issues
- Important performance problems
- Missing critical tests or error handling
- Substantial deviations from project patterns

### Minor concerns

- Style inconsistencies or formatting issues
- Opportunities for minor refactoring
- Additional test cases that would be nice to have
- Documentation improvements
- Keep these very concise and actionable
```

## Review guidelines

- **Be Constructive**: Explain the "why" behind feedback, not just "what" is wrong
- **Prioritize**: Security > Correctness > Quality > Style
- **Be Balanced**: Acknowledge both strengths and areas for improvement
- **Be Actionable**: Give clear, specific guidance on how to address issues
- **Consider Scale**: For large PRs, group similar issues rather than listing every instance
- **Respect Patterns**: Defer to project-specific patterns over generic best practices when they conflict
- **No Flattery**: Avoid "Great job," "Thanks for," or similar. Be matter-of-fact and helpful.
