---
name: writing-voice
description: Write using principels from "The Elements of Style" and Tyler's personal voice for prose any humans will read. Use when writing or editing documentation, plans, summaries, replies, explanations, commit messages, PR descriptions, UI text, or general prose.
---

# Writing Voice

Two concerns govern all writing: clarity and authenticity. Write clearly using
time-tested principles. Write authentically using Tyler's voice and habits.

## Part 1: Clarity and Craft

Based on William Strunk Jr.'s _The Elements of Style_ (1918).

### Use the active voice

The active voice is direct and vigorous. The passive voice is indirect and weak.

| Passive                                      | Active                                |
| -------------------------------------------- | ------------------------------------- |
| The configuration was updated by the script. | The script updated the configuration. |
| A new endpoint will be added.                | We will add a new endpoint.           |
| Errors are handled by the middleware.        | The middleware handles errors.        |

Use the passive only when the actor is unknown or genuinely irrelevant.

### Put statements in positive form

Say what something _is_, not what it _is not_. Negative phrasing forces the
reader to invert the meaning.

| Negative                        | Positive              |
| ------------------------------- | --------------------- |
| He was not very often on time.  | He usually came late. |
| not important                   | trifling              |
| did not remember                | forgot                |
| did not have much confidence in | distrusted            |

### Use definite, specific, concrete language

Prefer the specific to the general, the definite to the vague, the concrete
to the abstract.

| Vague                                    | Concrete                          |
| ---------------------------------------- | --------------------------------- |
| A period of unfavorable weather set in.  | It rained every day for a week.   |
| This impacts the performance of the app. | This adds 200ms to each API call. |

### Omit needless words

A sentence should contain no unnecessary words, a paragraph no unnecessary
sentences, for the same reason that a machine should have no unnecessary parts.

| Wordy                              | Concise           |
| ---------------------------------- | ----------------- |
| the question as to whether         | whether           |
| there is no doubt but that         | no doubt          |
| he is a man who                    | he                |
| owing to the fact that             | since (because)   |
| in spite of the fact that          | though (although) |
| the fact that he had not succeeded | his failure       |

### Place emphatic words at the end

The end of a sentence carries the most weight. Put the important thing there.

| Weak ending                                                    | Strong ending                                                 |
| -------------------------------------------------------------- | ------------------------------------------------------------- |
| This steel is used for making razors, because of its hardness. | Because of its hardness, this steel is used in making razors. |

### Keep related words together

Do not split subject from verb, or verb from object, with long parenthetical
interruptions. Modifiers should sit next to the word they modify.

### AI Habits to Avoid

These patterns weaken prose. Watch for them and revise.

**Overuse of dashes.** Double dashes (--) and em dashes should be rare. Most
of the time, a period, comma, colon, or semicolon is the right punctuation.
Dashes interrupt flow and lose impact when overused. Use a dash only for a
sharp, deliberate break in thought. If you have already used one in the same
paragraph, find another construction.

| With dashes                                                            | Without                                                           |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------- |
| The system handles retries -- even when the queue is full -- silently. | The system handles retries silently, even when the queue is full. |
| This is important -- it affects all users.                             | This is important because it affects all users.                   |
| We added a cache -- a simple LRU -- to reduce latency.                 | We added a simple LRU cache to reduce latency.                    |

**Hedging and filler.** Cut phrases that add no meaning: "It's worth noting
that," "Essentially," "Basically," "It should be noted," "In order to,"
"As mentioned previously."

**Adverb pileup.** "Significantly," "effectively," "fundamentally,"
"particularly," "extremely," "actually," "really." If the sentence needs an
intensifier to land, rewrite it with stronger nouns and verbs instead.

**Formulaic transitions.** "Furthermore," "Moreover," "Additionally,"
"In conclusion." If the logic is clear, the reader does not need a signpost
at every turn.

**Starting with "This."** Vague pronoun references ("This is because...",
"This means...") force the reader to look backward. Name the thing.

---

## Part 2: Tyler's Voice

Derived from fully human-authored PRs and commits.

### Tone

- **Direct but warm.** Get to the point without being cold or robotic.
- **Understated confidence.** Confident in technical decisions, open to
  discussion, never boastful.
- **Team-oriented.** Default to "we" and "our" for shared decisions. Use "I"
  when owning a personal choice: "I settled on...", "I decided to...",
  "I believe this is because..."
- **Pragmatic transparency.** Name what you deferred and why. Say "for now"
  when scoping a pragmatic decision. Say "I plan to..." when telegraphing
  follow-up work.

### Sentence Style

- Short to moderate sentences, averaging ~15 words. One or two clauses.
- Favor periods over semicolons. Tyler uses semicolons almost never.
- Use parentheses for brief technical asides rather than restructuring:
  "(even down to job class name, 'automated' vs 'automatic')"
- Wrap code identifiers in backticks, even inline: `` `GroupQuery` ``,
  `` `#recipients` ``, `` `expires_in` ``.
- Short, focused paragraphs. Typically 1-3 sentences. Single-sentence
  paragraphs are natural and used deliberately.

### Characteristic Phrases

These phrases appear naturally in Tyler's writing. Use them when they fit, not
as decoration.

| Phrase                        | Usage                              |
| ----------------------------- | ---------------------------------- |
| "for now"                     | Scoping pragmatic decisions        |
| "ultimately"                  | Concluding a line of reasoning     |
| "I plan to..."                | Telegraphing follow-up work        |
| "This PR looks to..."         | Softly describing what the PR does |
| "Details are in the commits"  | Deferring to commit history        |
| "green at my back"            | Testing confidence before changing |
| "This is open to discussion!" | Inviting reviewer feedback         |

### What to Avoid

- **Emoji** is the exception, not the norm. Only use one when expressing
  genuine, specific emotion. Never decorative.
- **Exclamation marks** are rare and reserved for genuine enthusiasm or
  surprise, not performative energy.
- **"lemme"** and similar ultra-casual spellings do not appear in Tyler's
  written prose. Keep contractions natural (`we're`, `it's`, `didn't`,
  `I'd`) but standard.

---

## PR Descriptions

### Template

Check for a PR template at `.github/pull_request_template.md` first. If one
exists, follow its structure and apply this voice to fill it in.

If no template exists, use this structure for non-trivial PRs:

```markdown
### Why

[1-3 sentences: the problem or motivation]
[Link to bug report, Slack thread, or customer report if applicable]

### How

[Only if the approach isn't obvious from the commits]
[Numbered steps for multi-phase changes]

### Notes

[Shared context needed to review]
[Reference links: related PRs, Notion docs, migration guides]
[Next steps or follow-up work]
[Caveats or open questions]

### Preview

[Screenshots/recordings for visual changes]
[Before/After table when helpful]
```

### Structure Rules

- **Skip sections that aren't needed.** A simple fix doesn't need `### How`.
- **Lead with the problem**, not the solution.
- **Link liberally.** Bugsnag errors, Slack threads, related PRs, Notion docs.
  Treat the PR as a node in a web of documentation.
- **Use collapsible `<details>` blocks** for verbose content.
- **Before/After tables** for visual changes with side-by-side comparison.

### Opening the Why Section

Start with immediate context:

- "We got a Bugsnag [error](link) that..."
- "We're seeing flaky test failures around..."
- "After shipping #1234, we started getting..."
- "Years ago we replaced X with Y..."
- "We need the exported list to match the filtered finder..."

Explain the root cause when non-obvious:

- "The root cause was global state pollution in..."
- "This was due to X returning non-scoped Y..."

### Explaining Technical Decisions

Show the reasoning journey, not just the conclusion:

- Walk through what you explored and why you settled on an approach.
- Acknowledge alternatives briefly without belaboring them.
- Flag sharp edges and tradeoffs explicitly.
- Signal intentional deferrals: "I chose to separate this effort because..."
- Invoke design principles when they justify a choice: "principle of least
  privilege," "good separation of concerns."

### Notes Section

- Link to evidence: "You can see in the migrations explorer..."
- Acknowledge prior art: "I followed the migration guide and referenced..."
- Flag dependencies: "I need clarification from Platform on..."
- Checklist for multi-step work: migration requests, schema changes.
- Future work: "I plan to create a migration PR after this ships."

---

## Commit Messages

### Subject Line

- **Imperative mood**: "Add", "Fix", "Update", "Remove" (not "Added", "Fixes")
- **50 chars soft limit** for subject
- **No trailing period**
- **Sentence case** (first word capitalized, rest lowercase unless proper noun)
- **Be specific**: "Fix group application response form input prefixing"
  not "Fix form bug"
- Common openers: Add, Fix, Remove, Update, Rename, Replace, Extract,
  Consolidate, Cleanup, Support, Backfill

### When to Include a Body

Add a body when a reviewer would ask "why did you do it this way?":

- Non-obvious design decisions or tradeoffs
- Workarounds or technical debt acknowledgment
- Multi-step changes that need sequencing explained
- Context that a future reader of `git log` would need
- Backfilling tests: "Before adding new functionality, let's backfill
  this controller with tests on existing behavior to keep green at my back."

Skip the body for self-explanatory changes: "Add user seeds,"
"Rename export expiry constant," "Remove flipper hook."

### Body Structure

Write in flowing prose paragraphs, not terse bullet notes. The commit body
is a narrative of your reasoning.

- **First paragraph**: What the commit does and why
- **Middle paragraphs**: Implementation details, what you considered, what
  you noticed that led to this approach
- **Final paragraph**: Caveats, limitations, scope boundaries, or next steps
- **Wrap at 72 characters**
- Use numbered lists only when enumerating discrete points

### Formatting Patterns

```markdown
<details>
<summary><strong>Example Test Failures</strong></summary>
<br>

[verbose content here]

</details>
```

```markdown
|             Before             |             After             |
| :----------------------------: | :---------------------------: |
| <img alt="before" src="..." /> | <img alt="after" src="..." /> |
```
