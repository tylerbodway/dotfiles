---
description: Review code changes (diff, commit, branch, or PR)
agent: plan
---

You are conducting a comprehensive code review.

---

Input: $ARGUMENTS

---

## Step 1: Determine What to Review

Based on the input provided, determine which type of review to perform:

1. **No arguments (default)**: Review all uncommitted changes
   - Run: `git diff` for unstaged changes
   - Run: `git diff --cached` for staged changes
   - Run: `git status --short` to identify untracked (net new) files

2. **Commit hash** (40-char SHA or short hash): Review that specific commit
   - Run: `git show $ARGUMENTS`

3. **Branch name**: Compare the specified branch to HEAD
   - Run: `git diff $ARGUMENTS...HEAD`

4. **PR URL or number** (contains "github.com" or "pull" or looks like a PR number): Review the pull request
   - Run: `gh pr view $ARGUMENTS` to get PR context
   - Run: `gh pr diff $ARGUMENTS` to get the diff

Use best judgement when processing input.

**Additional reviewer concerns**: $2

If additional reviewer concerns are provided above, keep them in mind throughout the entire review. Address them within the relevant existing sections of the report where they naturally fit (e.g., security concerns in the Security Review, correctness concerns in Critical Issues or Major Concerns). Only add a separate **Additional Concerns** section if a concern doesn't belong in any standard section.

## Step 2: Gather Context

**Diffs alone are not enough.** After getting the diff, read the full file(s) being modified to understand surrounding context. Code that looks wrong in isolation may be correct given surrounding logic, and vice versa.

- Use the diff to identify which files changed
- Use `git status --short` to identify untracked files, then read their full contents
- Read full files to understand existing patterns, control flow, and error handling
- Check for project-specific coding standards (AGENTS.md, CLAUDE.md, .editorconfig, etc.) and use them as the primary reference for pattern and style matching

For PR reviews, also check if the diff exceeds 5000 lines. If it does, display a warning:

```
WARNING: This PR has a very large diff (>5000 lines).
Reviewing such a large change may take significant time and context.

Please confirm you want to proceed with the review.
Type 'yes' to continue or 'no' to cancel.
```

Wait for user approval before continuing. If the user doesn't confirm, stop the review.

## Step 3: Conduct the Review

Analyze the changes across these dimensions:

### Bugs and Correctness (primary focus)

- Logic errors, off-by-one mistakes, incorrect conditionals
- Missing guards, incorrect branching, unreachable code paths
- Edge cases: null/empty/undefined inputs, error conditions, race conditions
- Broken error handling that swallows failures or throws unexpectedly
- Async operations handled incorrectly (promises, error handling)
- Unintentional behavior changes

### Security

- Injection, XSS, CSRF vulnerabilities
- User input not validated or sanitized
- Authentication and authorization handled incorrectly
- Secrets or sensitive data exposed (API keys, passwords, tokens)
- Unsafe operations or deprecated APIs
- Timing attacks or information disclosure risks

### Pattern and Style Matching

- Does the code follow patterns established in AGENTS.md/CLAUDE.md?
- Is it consistent with the existing codebase style?
- Are there deviations from project conventions that need addressing?
- Are naming conventions consistent with the project?

### Simplicity

- Is the solution as simple as possible while meeting requirements?
- Unnecessary complexity or over-engineering?
- Violations of YAGNI?

### Performance (only flag if obviously problematic)

- O(n²) on unbounded data, N+1 queries, blocking I/O on hot paths
- Missing resource cleanup (connections, file handles, timers)
- Unnecessary re-renders or re-computations

### Testing

- Does the change include tests for new functionality?
- Are test cases comprehensive (happy path + edge cases + error cases)?
- Are there obvious untested scenarios?
- Do tests actually validate the intended behavior?

### Documentation

- Is complex logic or business rules explained?
- Are necessary README or documentation updates included?
- Are API changes documented?
- Are breaking changes highlighted?

## Review Discipline

**Be certain.** If you call something a bug, be confident it actually is one.

- Only review the changes. Do not review pre-existing code that wasn't modified.
- Don't flag something as a bug if you're unsure. Investigate first.
- Don't invent hypothetical problems. If an edge case matters, explain the realistic scenario where it breaks.
- If you need more context, use the Explore agent, Exa Code Context, or Exa Web Search to verify before flagging.
- If you still can't verify, say "I'm not sure about X" rather than flagging it as a definite issue.

**Don't be a zealot about style.** When checking against conventions:

- Verify the code is _actually_ in violation. Don't complain about else statements if early returns are already used correctly.
- Some "violations" are acceptable when they're the simplest option. A `let` statement is fine if the alternative is convoluted.
- Excessive nesting is a legitimate concern regardless of other style choices.
- Don't flag style preferences as issues unless they clearly violate established project conventions.

## Step 4: Generate Review Report

### Summary

- Title/scope and brief description
- Number of files changed and lines added/removed
- Key areas of the codebase affected

### Strengths

- What is done well
- Good practices demonstrated
- Effective solutions or approaches

### Critical Issues (must fix before merge)

- Security vulnerabilities or exploits
- Breaking changes or bugs that will cause failures
- Data loss or corruption risks
- Include specific file paths and line references (e.g., `src/auth.js:45`)
- Explain the impact and provide specific fix recommendations

### Major Concerns (should address)

- Significant code quality or design issues
- Important performance problems
- Missing critical tests or error handling
- Substantial deviations from project patterns
- Include specific file paths and line references
- Explain why these are concerns and suggest improvements

### Minor Suggestions (optional improvements)

- Style inconsistencies or formatting issues
- Opportunities for minor refactoring
- Additional test cases that would be nice to have
- Documentation improvements
- Keep these concise and actionable

### Security Review

- Detailed security analysis with specific findings
- List potential vulnerabilities by type (injection, XSS, auth, etc.)
- Rate security risk: **None** / **Low** / **Medium** / **High** / **Critical**
- Provide specific remediation steps for any issues found

### Overall Assessment

- **Risk Level**: Low / Medium / High
- **Confidence**: How confident are you in the safety of these changes?
- **Recommendation**:
  - **Approve**: Safe to merge with no blocking issues
  - **Request Changes**: Blocking issues must be addressed
  - **Needs Discussion**: Architectural or design questions to resolve
- Reasoning behind the recommendation

### Actionable Recommendations

- Prioritized list of next steps (most important first)
- Specific fixes or improvements to make
- Testing recommendations
- Any follow-up work needed after merge

## Review Guidelines

- **Be Specific**: Always reference file paths and line numbers (`path/to/file.js:123`)
- **Be Constructive**: Explain the "why" behind feedback, not just "what" is wrong
- **Prioritize**: Security > Correctness > Quality > Style
- **Be Balanced**: Acknowledge both strengths and areas for improvement
- **Be Actionable**: Give clear, specific guidance on how to address issues
- **Consider Scale**: For large PRs, group similar issues rather than listing every instance
- **Respect Patterns**: Defer to project-specific patterns over generic best practices when they conflict
- **No Flattery**: Avoid "Great job," "Thanks for," or similar. Be matter-of-fact and helpful.
