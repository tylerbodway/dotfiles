---
name: propose-pr
description: Propose a GitHub pull request title and description for the current branch, then open the pre-filled "new pull request" page in the browser for the user to review and submit. Use whenever the user wants to propose, open, draft, prep, or write up a PR.
---

# Propose PR

Turn the current branch into a pull request draft: a title and description that explain the change, loaded into GitHub's compare page so the user can review, tweak, and submit it themselves.

Only open the pre-filled form. Don't run `gh pr create` or call any API that creates the PR. The user wants the final say before anything is public.

## Workflow

### 1. Gather branch facts

```bash
git branch --show-current
git remote get-url origin
git symbolic-ref --short refs/remotes/origin/HEAD   # default base, e.g. origin/main
git fetch origin
git rev-parse --verify --quiet origin/<branch>
```

- **Base branch:** use the repo default unless the branch was clearly cut from another feature branch (stacked PR). If `git log <default>..HEAD` includes commits that belong to a different branch, ask which base to use.
- **Pushed?** The compare page only works once the branch exists on the remote. If `origin/<branch>` is missing, or local is ahead of it (`git status -sb`), tell the user and ask them to push (or push for them if they approve). Wait until it's pushed before opening the URL, or the form will show the wrong diff.
- **Nothing to propose?** If there are no commits between base and HEAD, say so and stop.
- **Issue ID:** note whether the branch name contains one (e.g. `tb/fix-bug/eng-123` → `ENG-123`). See the description rules below for why that matters.

### 2. Understand intent and implementation

A good description explains _why_ the change exists, and that rarely lives in the diff. Collect it from two places:

- **Intent (why):** start with the current session. What problem did the user describe? What did you decide together, what alternatives came up, what tradeoffs were accepted? Then look for planning artifacts tied to this work: plans, specs, or notes in places like `.docs/`, `.opencode/plans/`, `PLAN.md`, or files mentioned in the session. Read the ones that relate to this branch.
- **Implementation (what):** read the commits, since they're the story the author meant to tell.
  ```bash
  git log --reverse --format='%h %s%n%n%b' <base>..HEAD
  git diff --stat <base>...HEAD
  ```
  Read the full diff (`git diff <base>...HEAD`) for anything the messages don't explain, or when the change is small enough to take in whole.

If intent isn't clear from the session, the artifacts, or the commit bodies, ask the user one or two targeted questions rather than inventing a rationale. A made-up "why" is worse than a short one.

### 3. Find the repo's PR template

Look for a template (case-insensitive) in `.github/`, the repo root, and `docs/`:

- `pull_request_template.md`
- `PULL_REQUEST_TEMPLATE/*.md` (multiple templates: pick the one that fits the change, or ask if it's unclear)

```bash
git ls-files | grep -i 'pull_request_template'
```

If there isn't one, use [assets/default-template.md](assets/default-template.md).

### 4. Write the title

The title says what the PR _does_. The description carries the detailed why.

- Imperative mood: "Add", "Fix", "Remove", not "Adds" or "Added".
- Make the scope clear: name the feature, area, or component affected.
- Hint at the why or the problem solved when it fits naturally ("Fix N+1 query on group roster page", "Cache feature flags to reduce boot time").
- Keep it under about 50–72 characters. Sentence case, no trailing period.
- Leave out issue IDs and conventional-commit prefixes unless the repo's history or template uses them.

| Weak                      | Better                                        |
| ------------------------- | --------------------------------------------- |
| `Updates`                 | `Add CSV export to attendance reports`        |
| `Fixed bug with form`     | `Fix duplicate submissions on signup form`    |
| `Refactor stuff for perf` | `Batch roster queries to speed up group page` |

### 5. Write the description

**Follow the repo template first.** Its structure, headings, and instructions beat everything else here. Specifically:

- Fill in its sections in its order. Drop a section only if it clearly doesn't apply and the template doesn't require it.
- Treat HTML comments (`<!-- ... -->`) as instructions: follow them, then remove them from the output.
- Keep the template's markup as written. If it uses HTML like `<details>` or `<h3>`, don't convert it to markdown.
- Leave checklists as checklists. Only check items that are actually true.

**Using the default template:** the bullets under each heading are prompts to answer, not text to keep. Replace them with real answers, and drop any heading that has nothing worth saying (a backend refactor usually has no Preview). The two lines at the top are guidance for you. Replace them with a short summary if one helps, otherwise remove them.

**Writing guidelines (for any template):**

- Use well-formatted GitHub-flavored markdown: short paragraphs, bullet lists, fenced code blocks with language tags, links.
- Explain the why, the context, and the tradeoffs. Don't replay the commit list. Reviewers will read the commits, so describe the overall approach or the arc of the branch instead. Don't write "see commits for details". Reviewers already know.
- Wrap supporting material in `<details>` when it helps but would clutter the main read: long logs, benchmarks, big code samples, alternatives you rejected, background research. Leave a blank line after `<summary>` so the markdown inside renders:

  ```html
  <details>
    <summary>Benchmark results</summary>

    | Case | Before | After | | --- | --- | --- | | 1k rows | 840ms | 120ms |
  </details>
  ```

- Add a mermaid diagram when a picture beats prose: request or job sequencing, state machines, data model or relationship changes, before/after flows. Skip it for simple changes. A diagram has to earn its space.
  ````markdown
  ```mermaid
  sequenceDiagram
    Browser->>API: POST /exports
    API->>Queue: enqueue ExportJob
    Queue-->>Browser: email with download link
  ```
  ````
- **If the branch name contains an issue ID, don't mention or link the issue in the description.** The issue tracker integration already links the PR from the branch name, so a reference would just be noise. Other references (docs, related PRs, Slack threads the user shared) are fine.
- Be accurate. Only claim tests, verification steps, or behavior you actually saw in the session or the code. For "How to verify", give concrete steps a reviewer can follow.

### 6. Build and open the URL

Write the body to a temp file so markdown survives shell quoting, then build the URL with the bundled script (paths are relative to this skill's directory):

```bash
body="$TMPDIR/pr-body.md"   # write the description here with your file-writing tool
scripts/build-url.sh --title "<title>" --body-file "$body" --base <base>
open "<printed url>"
```

The script reads `origin` to find the host and `owner/repo`, defaults `--head` to the current branch, and URL-encodes everything.

If it warns that the URL is too long (about 8KB or more), GitHub may cut off the body. In that case, copy the body to the clipboard (`pbcopy < "$body"`), open the URL built with an empty body, and tell the user to paste it in.

### 7. Hand off

Give the user a short wrap-up:

- The title, and the description in a fenced markdown block so they can read it without switching windows.
- The base branch you used, and anything you weren't sure about (a guessed base, a template section you left out, intent you inferred).

Remind them that nothing has been submitted: they review and create the PR in the browser.
