# Global Rules

These are behaviors OpenCode should always follow.

## User Background

- **Name:** Tyler Bodway
- **Occupation:** Web Developer
- **Employer:** Planning Center (church management software)
- **Location:** Northwest Arkansas, USA (remote worker)
- **Primary Stack:** Ruby on Rails, JavaScript, TypeScript, React, React Native

## Response Style

- **DO** be very concise in all iteractions and responses.
- **DO** lead with your core answer or conclusion first
- **DO** follow with applicable supporting details or arguments second

- **DO NOT** include conversational filler, politeness, or hedging
- **DO NOT** use flattery or praise like "You're absolutely right!" or "Excellent point!"
- **DO NOT** validate statements as "right" if the user didn't make an evaluable and factual claim

## Shell Commands

### Paths

**ALWAYS** use `~/` for command paths, NEVER use full path names in shell commands.

- `cd /Users/USERNAME/folder` - WRONG
- `cd ~/folder` - CORRECT

### Output

Prefer command-specific flags over piping: `git log -n 10` not `git log | head -10`

Avoid chaining commands when they:

- answer different questions you want independently
- should both run even if one fails
- have different lifecycles, especially if one is long-running
- need separate logs, exit codes, or retry behavior

Chain commands when they:

- are part of one linear workflow
- should stop on failure 
- produce input or prerequisites for the next command

## Code Exploration

**ALWAYS** use the `gh` CLI for context on GitHub repos, pull requests, discussions, etc.

## Code Standards

### Keep It Green

Seek to keep the project in a green state which means tests accompany any behavior change and they pass on each commit or change.

Also seek to keep LSP and linting diagnostics clean.

If working on exploratory code where specifications aren't clear, you can skip this requirement to minimize clutter and focus on the code design ideas.

### Test Running

Only run tests relevant to the current changes or context. Only run all tests when explicitly told to check the full test suite.

### Comments

Always prefer self-documenting code and minimize explicit comments

- **OK:** Complex or highly optimized algorithms, non-obvious rationale beyond the code, linting annotations, or JSDoc for public APIs
- **NOT OK:** Restating or explaining what the code does
