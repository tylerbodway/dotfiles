---
name: propose-pr
description: Generates a GitHub PR title and description, then opens and autofills the new PR page. Use when user asks you to propose a PR.
---

## What I do

- Detect the current git branch and repository
- Analyze git commits and code changes compared to the base branch (defaults to `main`)
- Read and follow the `.github/PULL_REQUEST_TEMPLATE.md` or `.github/pull_request_template.md` if it exists
- Generate a suggested PR title based on the changes
- Generate a PR description following the template structure (if available)
- Construct and open the GitHub PR comparison URL with pre-filled title and description

I will NOT actually create or submit the PR - I only open the GitHub page with suggestions so you can review and submit it yourself.

## Instructions

1. **Get repository information**:
   - Run `git remote get-url origin` to get the repository URL
   - Parse owner and repo name from the URL
   - Get current branch with `git branch --show-current`

2. **Verify branch is pushed to origin**:
   - Run `git fetch origin` to ensure remote refs are up to date
   - Run `git rev-parse --verify origin/<branch>` to check if the branch exists on the remote
   - If the branch is not pushed, notify the user and ask if they want you to push it with `git push -u origin <branch>`
   - Do NOT proceed to open the PR URL until the branch exists on origin

3. **Check for PR template**:
   - Look for `.github/PULL_REQUEST_TEMPLATE.md` or `.github/pull_request_template.md`
   - If found, read the template file carefully

4. **Analyze changes**:
   - Run `git log main..HEAD --oneline` (or appropriate base branch) to see commits
   - Run `git diff main...HEAD` to see the actual code changes
   - Understand what the PR is accomplishing

5. **Generate PR content**:
   - Create a concise, descriptive PR title (one line summary)
   - Write a PR description:
     - **If a PR template exists**: You MUST follow the template exactly and fill in each section appropriately. If a section does not apply, feel free to omit it.
     - **Preserve all markup as-is**: If the template uses HTML tags (e.g., `<details>`, `<summary>`, `<h3>`), keep them as HTML — do NOT convert them to Markdown equivalents.
     - **If no template exists**: Write a description that summarizes what changed and why, includes relevant context from commits and diffs, and uses proper markdown formatting.
     - **Do not repeat commits**: It's okay to describe high-level strategy or branch arcs, but do not repeat what commits already communicate. Never say "details are in the commits" — that's obvious.

6. **Build and open URL**:
   - Use the bundled script (relative to this skill's base directory) to construct the URL:
     ```bash
     <skill-base>/scripts/build-url.sh <owner> <repo> <base> <head> "<title>" "<body>"
     ```
   - The script handles URL-encoding and outputs the full GitHub compare URL
   - Open with: `open "$(<skill-base>/scripts/build-url.sh ...)"`

## Dependencies

Before generating PR content, load the `writing-voice` skill and follow its guidelines.

## Notes

- If the base branch is not `main`, ask the user or try to detect it with `git symbolic-ref refs/remotes/origin/HEAD`
- Keep the PR title under 72 characters if possible
- Ensure the description is well-formatted markdown
- If there are no commits on the current branch vs base, notify the user
