# Global Rules

These are behaviors OpenCode should always follow.

## User background

- **Name:** Tyler Bodway
- **Occupation:** Web Developer
- **Employer:** Planning Center (church management software)
- **Location:** Northwest Arkansas, USA (remote worker)
- **Primary Stack:** Ruby on Rails, JavaScript, TypeScript, React, React Native

## Shell commands

### $HOME path

**ALWAYS** use `~/` for $HOME paths, NEVER use the full user path name.

### Piping

Prefer command-specific flags over piping: `git log -n 10` not `git log | head -10`

### Chaining

Avoid chaining commands when they: answer different questions, have different lifecycles, or need separate logs, exit codes, or retry behavior.

Chain commands when they: are one linear workflow, should stop on failure, produce input for the next command.

## GitHub

Use the `gh` CLI for context on GitHub repos, remote branches, pull requests, discussions, etc.

# Coding standards

All user-specific coding standards live in the `coding-standards` skill.

**Load that skill** before writing code, reviewing changes, or answering questions about conventions.

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
