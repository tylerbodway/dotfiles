---
name: coding-standards
description: User-specific coding standards. Use whenever writing or reviewing code in any project, conducting a code review, or implementing any feature.
---

# Coding standards

## Keep It Green

Always seek to keep projects in a "green" CI state:

- Tests accompany any behavior change
- Relevant tests, type checks, and linters are passing

If working on exploratory or spike code, you can skip this requirement.

## Running tests

Only run tests relevant to the current context. Only run the full test suite when explicitly told to do so.

## Comments

Always prefer self-documenting code and minimize explicit comments.

GOOD: for complex or highly optimized algorithms, non-obvious rationale, linters, or API documentation.
BAD: Restating or explaing what code does.
