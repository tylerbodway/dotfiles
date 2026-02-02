---
name: propose-pr
description: Generate and propose a PR title and description, then open GitHub's new PR page.
---

## What I do

- Detect the current git branch and repository
- Analyze git commits and code changes compared to the base branch (defaults to `main`)
- Read and follow the `.github/PULL_REQUEST_TEMPLATE.md` or `.github/pull_request_template.md` if it exists
- Generate a suggested PR title based on the changes
- Generate a PR description following the template structure (if available)
- Construct and open the GitHub PR comparison URL with pre-filled title and description

## When to use me

Use this skill when you're ready to propose a pull request but want AI assistance with:

- Writing a comprehensive PR description
- Following the repository's PR template
- Generating an appropriate PR title

I will NOT actually create or submit the PR - I only open the GitHub page with suggestions so you can review and submit it yourself.

## Instructions

1. **Get repository information**:
   - Run `git remote get-url origin` to get the repository URL
   - Parse owner and repo name from the URL
   - Get current branch with `git branch --show-current`

2. **Check for PR template**:
   - Look for `.github/PULL_REQUEST_TEMPLATE.md` or `.github/pull_request_template.md`
   - If found, read it and use its structure for the description

3. **Analyze changes**:
   - Run `git log main..HEAD --oneline` (or appropriate base branch) to see commits
   - Run `git diff main...HEAD` to see the actual code changes
   - Understand what the PR is accomplishing

4. **Generate PR content**:
   - Create a concise, descriptive PR title (one line summary)
   - Write a PR description that:
     - Follows the template structure if one exists
     - Summarizes what changed and why
     - Includes relevant context from commits and diffs
     - Uses proper markdown formatting

5. **Build and open URL**:
   - Construct the GitHub compare URL:
     `https://github.com/OWNER/REPO/compare/BASE...HEAD?expand=1&title=TITLE&body=DESCRIPTION`
   - URL-encode the title and body parameters properly
   - Open the URL using `open` (macOS) or appropriate command for the platform

## Notes

- If the base branch is not `main`, ask the user or try to detect it with `git symbolic-ref refs/remotes/origin/HEAD`
- Keep the PR title under 72 characters if possible
- Ensure the description is well-formatted markdown
- If there are no commits on the current branch vs base, notify the user
