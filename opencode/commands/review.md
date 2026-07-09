---
description: Review code changes (diff, commit, branch, or PR)
---

Run a `code-review` skill session.

**Review context:** $1

1. **No arguments (default)**: Review all uncommitted changes
2. **Commit hash** (40-char SHA or short hash): Review that specific commit
3. **Branch name**: Review the specified branch against its base
4. **PR URL or number** (contains "github.com", "pull", "pr", or looks like a PR number): Review the pull request against its base

If user provides any additional concerns, be sure to address these concerns within the relevant report sections.

**Additional reviewer concerns**: $2

---

If reviewing a commit, branch, or PR, you **must** git checkout the relevant changes before reading and comparing local files.

If there is a dirty git status, **stop** and ask the user how they'd like to handle their changes.

After the final report, revert to the git state before this review. If you pulled a remote branch for this review, remove it, and checkout the original branch. If you stashed local changes, bring them back.
