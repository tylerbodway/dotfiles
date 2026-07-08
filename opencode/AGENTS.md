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

Never publish or post on behalf of the user without explicit consent.

## Code preferences

### Comments

Always prefer self-documenting code and minimize explicit comments.

GOOD: for complex or highly optimized algorithms, non-obvious rationale, linters, or API documentation.
BAD: Restating or explaing what code does.
