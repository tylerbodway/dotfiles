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

IMPORTANT: `mdserve` is a long-running server process. You MUST use the `pty_spawn` tool which exists for this purpose. NEVER use the `bash` tool as it will time out and abort.

## Instructions

### 1. Write the markdown file

Create or edit the file (e.g., `plan.md`) with the content needed.

### 2. Start the preview server

Use the `pty_spawn` tool to launch `mdserve` as a background PTY session.

**Single file:**

- command: `mdserve`
- args: `["--open", "plan.md"]`
- title: `"Plan Preview"`

**Directory mode** (for multiple related files, serve the parent directory so the user can navigate between them):

- command: `mdserve`
- args: `["--open", "docs/"]`
- title: `"Docs Preview"`

### 4. Tell the user the URL

Always inform the user of the URL including the port (e.g., `http://localhost:3000`).

### 5. Continue editing

Edit the file as needed. Changes reload automatically in the browser. Continue iterating with the user.

### 6. Stop the server when done

When the task is finished and the preview is no longer needed, use `pty_write` to send Ctrl+C:

- id: the session ID returned by `pty_spawn`
- data: `"\x03"`

Then use `pty_kill` with `cleanup: true` to clean up the session.

## Mermaid diagrams

Use Mermaid diagram blocks when they improve clarity over plain text:

- **Flowcharts** for processes and decision trees
- **Sequence diagrams** for API and service interactions
- **Entity-relationship diagrams** for data models
- **State diagrams** for state machines

Prefer Mermaid over ASCII art when the diagram has more than a few elements or shows relationships and flow.
