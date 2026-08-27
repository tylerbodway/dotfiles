# Global Rules

These are behaviors OpenCode should always follow.

## User background

- **Name:** Tyler Bodway
- **Occupation:** Web Developer
- **Employer:** Planning Center (church management software)
- **Location:** Northwest Arkansas, USA (remote worker)
- **Primary Stack:** Ruby on Rails, JavaScript, TypeScript, React, React Native

## Shell commands

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
BAD: Restating or explaining what code does.

## Temporary files

Scratch work goes in `$TMPDIR/opencode`: handoffs, PR bodies, repro scripts, extracted output, draft docs. Never the workspace, never `/tmp`.

Name the file after the task (`pr-body.md`, `repro-dedup.rb`). Reuse it instead of making a new one per step, report the absolute path, and leave it behind when you finish. macOS clears the directory.

## Output Style

When you write technical text (documentation, READMEs, runbooks, procedures, error messages, release notes, reports, commit messages, explanations to the user), obey these rules from ASD-STE100 Simplified Technical English:

CLASSIFY FIRST. Procedural text tells the reader what to do: imperative mood, maximum 20 words per sentence, one instruction per sentence. Descriptive text explains: simple tenses, maximum 25 words per sentence, one topic per paragraph, maximum six sentences per paragraph. Never mix the two in one passage.

VERBS. Use only: infinitive, imperative, simple present, simple past, simple future, past participle as adjective. No present perfect ("has completed" → "completed"). No "-ing" verb forms ("making it easy" → new sentence). Active voice; passive only in descriptions when the agent is unknown. Approved modals: can, will, must. Banned: should, would, may, might, could. For "should": write "must" if required, delete if optional.

SENTENCES. Keep complete grammar: no contractions, keep articles, keep "that" ("make sure that the file exists"). Put conditions before commands, with a comma: "If the test fails, read the log." No semicolons — write two sentences. Use a vertical list for more than two items or steps.

WORDS. One word, one meaning, for the whole document: pick one of check/verify/confirm and keep it. Noun chains of maximum three words; break longer ones with prepositions ("the timeout value for the connection pool"). Delete words that carry no fact: simply, seamlessly, robust, powerful, comprehensive, leverage, "in order to", "it is worth noting". Replace: utilize → use, prior to → before, in the event that → if, e.g. → for example. American spelling.

WARNINGS. Command or condition first, then the risk: "Do not run this against production. The command deletes rows."

NEVER TOUCH. Code blocks, identifiers, CLI commands, file paths, quoted error messages, product names. Each counts as one word toward sentence limits.

SELF-CHECK before returning prose: scan for contractions, "has been", "should", ", making", semicolons. Count words in your three longest sentences and split any over the limit. Collapse synonym rotation.

Do not apply these rules to code, code comments that quote code, or marketing copy the user asks for.
