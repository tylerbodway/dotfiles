---
name: technical-writing-voice
description: Write PR descriptions, commit messages, and technical documentation in Tyler's voice. Use when drafting git commits, pull requests, changelogs, or any developer-facing documentation.
---

# Technical Writing

Write PR descriptions, commit messages, and technical documentation that match Tyler's authentic voice and style.

## Voice Characteristics

### Tone

- **Direct but warm**: Get to the point without being cold or robotic
- **Humble expertise**: Confident in technical decisions, but open to discussion
- **Genuine enthusiasm**: Let personality shine through when something is exciting or frustrating
- **Collaborative**: Invite feedback, acknowledge team context, credit prior work

### Authenticity Markers

Use natural, conversational asides sparingly:

- "lemme know!" (not "let me know")
- "It bugged me enough to do something about it"
- "This is open to discussion though!"
- "I plan to..." / "We're choosing to believe the best..."
- Light emoji use when expressing genuine emotion (not decorative)

## PR Description Structure

**First, check for a PR template** at `.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE.md`. If one exists, follow its structure and apply the voice/patterns from this guide to fill it in.

**If no template exists**, use this default structure for non-trivial PRs:

```markdown
### Why

[1-3 sentences explaining the problem or motivation]
[Link to bug report, Slack thread, or customer report if applicable]

### How

[Only if the implementation approach isn't obvious from the commits]
[Numbered steps for multi-phase changes]

### Notes

[Shared context needed to review]
[Reference links: related PRs, Notion docs, migration guides]
[Next steps or follow-up work]
[Any caveats or open questions]

### Preview

[Screenshots/recordings for visual changes]
[Before/After comparisons in a table when helpful]
```

### Structure Rules

- **Skip sections that aren't needed** - a simple fix doesn't need `### How`
- **Lead with the problem**, not the solution
- **Link liberally** - Bugsnag errors, Slack threads, related PRs, Notion docs
- **Use collapsible details** for verbose content (stack traces, test failures)
- **Before/After tables** for visual changes with side-by-side comparison

### Why Section Patterns

Start with immediate context:

- "We got a Bugsnag [error](link) that..."
- "We had a HackerOne [report](link) where..."
- "After shipping #1234, we started getting..."
- "I noticed with a fresh `box reload-data` that..."
- "Product would like to..."
- "This removes the `[Annoying Log]` message you've likely seen in consoles..."

Explain the root cause when non-obvious:

- "The root cause was global state pollution in..."
- "This was due to X returning non-scoped Y..."

### Notes Section Patterns

- Link to evidence: "You can see in the migrations explorer this table is empty..."
- Acknowledge prior art: "I followed the migration guide and referenced..."
- Flag dependencies: "I need clarification from Platform on..."
- Checklist for multi-step work: migration requests, schema changes
- Future work: "I plan to create a migration PR after this ships"

## Commit Message Style

### Subject Line

- **Imperative mood**: "Add", "Fix", "Update", "Remove" (not "Added", "Fixes")
- **50 chars soft limit** for subject
- **No period** at end of subject
- **Be specific**: "Fix group application response form input prefixing" not "Fix form bug"

### Body (when needed)

Add a body for commits that need explanation:

```
Add inline form errors

Instead of rendering form errors as a list at the top, I used a custom
form builder to structure the form fields with helper text of the error
message, and ensured the HTML matched the visual error states of
pico.css.

Now all I have to do is use form_with_inline_errors in the future, and
error messages will appear beneath the fields as necessary!

The one drawback with this approach is I need to remember to add any
form helpers I use to the form builder, but that's an okay tradeoff for
now.
```

### Body Patterns

- **First paragraph**: What the commit does and why
- **Middle paragraphs**: Implementation details, tradeoffs considered
- **Final paragraph**: Caveats, limitations, or future improvements
- **Wrap at 72 characters**
- **Use "I" naturally** - it's your commit

### When to Add a Body

- Non-obvious implementation choices
- Workarounds or technical debt acknowledgment
- Multi-step changes that need sequencing explained
- Changes that might look wrong without context

### When to Skip the Body

- Self-explanatory changes: "Update version and changelog"
- Trivial fixes: "Fix typo in error message"
- Dependency bumps: "Bump pco-ops from 4.38.0 to 4.38.1"

## Writing Principles

### Lead with Context

Bad: "This PR updates the form helper."
Good: "When migrating this tag builder from `form_for` to `form_with`, I missed changing this option from `as:` to `scope:` to prefix the inputs properly."

### Be Transparent About Tradeoffs

- "Although I personally prefer X, I want to be in alignment with..."
- "The one drawback with this approach is..."
- "We're not sold on that quite yet"
- "This is strictly a refactor and should have no effect on current behavior"

### Show Your Work

- "I searched for any other instance of this bug and could not find others"
- "We confirmed in Redshift there hasn't been a legacy invitation created in years"
- "I've run this scheduled task locally to ensure it runs smooth"

### Acknowledge Uncertainty

- "The current hunch is that..."
- "I'm not sure if we're to remove the legacy X in this same step"
- "This is open to discussion though!"

## Examples

### Good PR Title

- "Fix flaky integration tests"
- "Migrate Turbolinks to Turbo"
- "H1: Fix `GroupMemberFinderPeople` vulnerability by trashing it"
- "Idempotent-ish improvements to automated email jobs"

### Good Commit Subject

- "Guard against canceled organizations in automated attendance requests"
- "Use custom group join in `SendAutomatedAttendanceRequestsJob`"
- "Only log enabled within Sidekiq server process"
- "Destroy new conversation if Stream API errors"

### Collapsible Details Pattern

```markdown
<details>
<summary><strong>Example Test Failures</strong></summary>
<br>

[verbose content here]

</details>
```

### Before/After Table Pattern

```markdown
|             Before             |             After             |
| :----------------------------: | :---------------------------: |
| <img alt="before" src="..." /> | <img alt="after" src="..." /> |
```
