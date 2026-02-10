---
description: Thoroughly review a GitHub PR for code quality, security, and best practices
agent: plan
subtask: true
---

You are conducting a comprehensive code review for GitHub Pull Request #$1.

## Step 1: Validate and Gather PR Information

First, verify the PR exists and gather basic information:

!`gh pr view $1 2>&1`

If the command above failed (PR doesn't exist, not authenticated, not a GitHub repo, etc.), explain what went wrong and stop here. Do not proceed with the review.

Get the full diff and count the lines:

!`gh pr diff $1 | wc -l`

**IMPORTANT**: If the diff is longer than 5000 lines, display a warning message:

```
⚠️  WARNING: This PR has a very large diff (>5000 lines).
Reviewing such a large change may take significant time and context.

Please confirm you want to proceed with the review.
Type 'yes' to continue or 'no' to cancel.
```

Wait for user approval before continuing. If the user doesn't confirm, stop the review.

Get the list of changed files:

!`gh pr view $1 --json files --jq '.files[].path' 2>&1`

Get the full diff for analysis:

!`gh pr diff $1 2>&1`

## Step 2: Load Project Standards

Check for project-specific coding standards and review guidelines:

- Look for AGENTS.md or CLAUDE.md in the project root (use @ references: @AGENTS.md or @CLAUDE.md)
- Review any patterns, conventions, or architectural decisions documented there
- Use these as the primary reference for pattern and style matching
- If these files don't exist, rely on general best practices and consistency with the existing codebase

## Step 3: Conduct Comprehensive Review

Analyze the PR across these dimensions:

### Code Quality

- Is the code readable and well-structured?
- Are variable and function names clear and meaningful?
- Is the code properly formatted and styled?
- Are there any code smells or anti-patterns?
- Is complexity reasonable (avoid deeply nested logic)?

### Correctness

- Does the logic appear sound and correct?
- Are edge cases handled properly?
- Is error handling comprehensive and appropriate?
- Are there any obvious bugs or logical errors?
- Are async operations handled correctly (promises, error handling)?

### Simplicity

- Is the solution as simple as possible while meeting requirements?
- Is there unnecessary complexity or over-engineering?
- Could any parts be simplified without losing functionality?
- Are there violations of YAGNI (You Aren't Gonna Need It)?
- Is the code DRY (Don't Repeat Yourself) where appropriate?

### Pattern & Style Matching

- Does the code follow the patterns established in AGENTS.md/CLAUDE.md?
- Is it consistent with the existing codebase style?
- Are there deviations from project conventions that need addressing?
- Does it follow the project's architectural decisions?
- Are naming conventions consistent with the project?

### Security Implications

- Are there any SQL injection, XSS, or CSRF vulnerabilities?
- Is user input properly validated and sanitized?
- Are authentication and authorization handled correctly?
- Are secrets or sensitive data exposed (API keys, passwords, tokens)?
- Are dependencies secure and up-to-date?
- Are there any unsafe operations or deprecated APIs?
- Is data properly encrypted in transit and at rest where needed?
- Are there timing attacks or information disclosure risks?

### Performance Considerations

- Are there any obvious performance issues?
- Are there N+1 query problems (database or API calls)?
- Are algorithms efficient for expected data sizes?
- Is there proper resource cleanup (connections, file handles, timers)?
- Are there unnecessary re-renders or re-computations?
- Is data fetching optimized (pagination, lazy loading, caching)?

### Testing

- Does the PR include tests for new functionality?
- Are test cases comprehensive (happy path + edge cases + error cases)?
- Are there any obvious untested scenarios?
- Do tests actually validate the intended behavior?
- Are test names descriptive and clear?

### Documentation

- Is the code adequately commented where needed (complex logic, business rules)?
- Are complex algorithms or business logic explained?
- Are there necessary README or documentation updates?
- Is the PR description clear and complete?
- Are API changes documented?
- Are breaking changes highlighted?

## Step 4: Generate Review Report

Provide a structured review report with the following sections:

### 📋 PR Summary

- Title, author, and brief description
- Number of files changed and lines added/removed
- Overall scope and purpose of the changes
- Key areas of the codebase affected

### ✅ Strengths

- What is done well in this PR
- Positive aspects worth highlighting
- Good practices demonstrated
- Effective solutions or approaches

### 🔴 Critical Issues (must fix before merge)

- Security vulnerabilities or exploits
- Breaking changes or bugs that will cause failures
- Data loss or corruption risks
- Include specific file paths and line references (e.g., `src/auth.js:45`)
- Explain the impact and provide specific fix recommendations

### 🟡 Major Concerns (should address)

- Significant code quality or design issues
- Important performance problems
- Missing critical tests or error handling
- Substantial deviations from project patterns
- Include specific file paths and line references
- Explain why these are concerns and suggest improvements

### 🟢 Minor Suggestions (optional improvements)

- Style inconsistencies or formatting issues
- Opportunities for minor refactoring
- Additional test cases that would be nice to have
- Documentation improvements
- Include specific file paths and line references
- Keep these concise and actionable

### 🔒 Security Review

- Detailed security analysis with specific findings
- List any potential vulnerabilities by type (injection, XSS, auth, etc.)
- Rate security risk: **None** / **Low** / **Medium** / **High** / **Critical**
- Provide specific remediation steps for any issues found

### 📊 Overall Risk Assessment

- **Risk Level**: Low / Medium / High
- **Confidence**: How confident are you in the safety of these changes?
- **Merge Recommendation**:
  - ✅ **Approve** - Safe to merge with no blocking issues
  - ⚠️ **Request Changes** - Blocking issues must be addressed
  - 💬 **Needs Discussion** - Architectural or design questions to resolve
- Explain the reasoning behind your recommendation

### 💡 Actionable Recommendations

- Prioritized list of next steps (most important first)
- Specific fixes or improvements to make
- Testing recommendations
- Any follow-up work needed after merge

## Important Review Guidelines

- **Be Specific**: Always reference file paths and line numbers for issues (format: `path/to/file.js:123`)
- **Be Constructive**: Explain the "why" behind feedback, not just "what" is wrong
- **Provide Context**: Consider the project's constraints and guidelines from AGENTS.md/CLAUDE.md
- **Prioritize**: Focus on high-impact issues first (security > correctness > quality > style)
- **Be Balanced**: Acknowledge both strengths and areas for improvement
- **Be Actionable**: Give clear, specific guidance on how to address issues
- **Consider Scale**: For large PRs, group similar issues rather than listing every instance
- **Respect Patterns**: Defer to project-specific patterns over generic best practices when they conflict
