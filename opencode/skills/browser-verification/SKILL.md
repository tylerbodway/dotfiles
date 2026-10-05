---
name: browser-verification
description: Drive a browser from the agent, two ways — terminal-browser (a visible browser in a herdr split pane the human can watch and take over) for interactive, user-simulated verification, and the devtools MCP (headless Brave, disabled by default) for console, network, performance traces, profiling, and screenshots. Use whenever the user wants anything verified, tested, clicked through, or debugged in a browser — "verify this", "click through", "simulate a user", "does it look right", "devtools", "screenshot", "why is it slow" — even when they don't name a tool.
---

# Browser Verification & Debugging

Two browser tools with different experiences for the human: one is a shared
window they watch and can grab, the other an invisible instrument panel.

## Routing

| The ask                                                                                              | Tool                                                      |
| ---------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| "Verify in a browser", "click through", "simulate a user", "check it looks right", "test end-to-end" | **terminal-browser**                                      |
| "Debug", "console", "network requests", "performance trace", "profile", "screenshot", "devtools"     | **devtools MCP**                                          |
| Visual verification plus deep inspection                                                             | terminal-browser first, then devtools MCP on the same URL |

The default for "verify in a browser" is **terminal-browser** — the human asked
to watch or intervene. Devtools is for internals (console, network,
performance, screenshots). When ambiguous, prefer terminal-browser: it costs
nothing, the human sees what happened, and you can follow up with devtools if
the visual pass surfaces something needing forensics.

## devtools availability

The devtools MCP is configured but **disabled by default**, so its tools are
often absent from your toolset. Before routing work to devtools, check whether
its tools exist. If not, tell the user plainly and give them the one-liner:
`/mcps` → select `devtools` → connect. Then wait.

Don't silently substitute terminal-browser when the ask was console, network,
traces, or screenshots — those signals don't exist there, and faking them
wastes the user's time. Don't launch Brave or start the MCP server via shell;
`/mcps` is the mechanism. terminal-browser needs no MCP, so it's never blocked.

## terminal-browser (visible, interactive)

```bash
terminal-browser open localhost:3000 --split right   # opens next to the agent pane
terminal-browser ls                                   # browsers + tab ids
terminal-browser action -- <command>                  # drive the open browser
terminal-browser action done                          # clears the "agent acting" indicator
```

- `open` accepts a url, a localhost port, or an html file path
  (`--split right|left|up|down`, `--size <fraction>`).
- `action` is agent-browser compatible: `snapshot`, `click @e14`,
  `fill @e3 "hello"`, `eval "document.title"`, plus CSS selectors
  (`click "#submit"`). Arguments go after `--`.
- After the last action, run `action done` so the acting indicator clears
  immediately instead of fading out.
- Leave the browser open when finished — the human may want to poke at it. It
  dies with the pane (ctrl+q).

Practical gotchas:

- **`pane_not_found`** usually means a stale `HERDR_PANE_ID` (common in
  subagents). Check live panes with `herdr pane list`, then override
  `HERDR_PANE_ID` / `HERDR_TAB_ID` / `HERDR_WORKSPACE_ID` and retry.
- Element refs (`@e7`) don't survive between CLI invocations — take a fresh
  `snapshot` per batch, and prefer CSS selectors when refs keep invalidating.
- Use `--no-merge` for an isolated instance when other agents may be using a
  shared browser; merged instances collide on tab focus and ref registries.
- If rendering still fails (terminal/multiplexer not passing the kitty
  graphics protocol), say so — the visual pass didn't happen — and fall back
  to devtools MCP.

## devtools MCP (headless, forensic)

Headless Brave — nothing on screen. Console: `list_console_messages`. Network:
`list_network_requests`, `get_network_request_detail`. Performance:
`performance_start_trace` / `performance_stop_trace` /
`performance_analyze_insight`. Debugging: `evaluate_script`, `take_screenshot`,
`take_snapshot`, `inspect_element`. Input simulation without visual feedback:
`click`, `fill`, `hover`, `drag`.

Prefer devtools over terminal-browser for anything needing structured output —
screenshots, request/response bodies, console errors, trace flame charts.

## Combining them

For "verify this flow and debug why it's slow": run the visual flow in
terminal-browser so the human can see and steer, then reproduce the specific
problem headlessly via devtools MCP for the trace or network detail. If
devtools is disabled, do the visual pass first, then ask the user to enable
it for the forensic half.
