---
name: markdown-preview
description: Live-reload markdown preview in the browser via mdserve. Use when creating or editing substantial markdown (plans, architecture docs, reports, tables, Mermaid diagrams, multi-file docs) or when the user asks to preview/render markdown.
---

## What I do

- Serve markdown files with live-reloading browser preview via `mdserve`
- Automatically open the preview in the user's browser
- Handle port conflicts and multi-file directory serving
- Keep the preview running during edit/review iterations, then clean up when done

## When to use me

Use when markdown is more than ~40-60 lines, has complex formatting (tables, diagrams, nested lists), or is likely to go through multiple edit/review iterations. Good candidates:

- Plans, proposals, and roadmaps
- Architecture or design documents
- Reports, comparisons, or summaries with tables
- Anything containing Mermaid diagrams
- Multi-file documentation sets
- Any time the user asks to "preview" or "render" markdown

Do NOT use for short conversational answers, single code snippets, trivial one-paragraph responses, or markdown that fits comfortably in a terminal window.

## Prerequisites

`mdserve` must be installed. If the command is not found, STOP and ask the user to install it before proceeding.

## Instructions

### 1. Write the markdown file

Create or edit the file (e.g., `plan.md`) with the content needed.

### 2. Check for port conflicts

Before starting the server, check if the default port is in use:

```
ss -tlnp | grep :3000
```

If port 3000 is occupied, use `--port` to pick another (e.g., 3001).

### 3. Start the preview server

Launch `mdserve` as a background session with `--open` to auto-open the browser:

**Single file:**

```
pty_spawn: command="mdserve", args=["--open", "plan.md"], title="Markdown Preview"
```

**With alternate port:**

```
pty_spawn: command="mdserve", args=["--open", "plan.md", "--port", "3001"], title="Markdown Preview"
```

**Directory mode** (for multiple related files, serve the parent directory so the user can navigate between them):

```
pty_spawn: command="mdserve", args=["--open", "docs/"], title="Markdown Preview"
```

### 4. Tell the user the URL

Always inform the user of the URL including the port (e.g., `http://localhost:3000`).

### 5. Continue editing

Edit the file as needed. Changes reload automatically in the browser. Continue iterating with the user.

### 6. Stop the server when done

When the task is finished and the preview is no longer needed, stop the session:

```
pty_write: id="TASK_ID", data="\x03"
```

## Mermaid diagrams

Use Mermaid diagram blocks when they improve clarity over plain text:

- **Flowcharts** for processes and decision trees
- **Sequence diagrams** for API and service interactions
- **Entity-relationship diagrams** for data models
- **State diagrams** for state machines

Prefer Mermaid over ASCII art when the diagram has more than a few elements or shows relationships and flow.
