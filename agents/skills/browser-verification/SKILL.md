---
name: browser-verification
description: Drive a browser from the agent, two ways — agent-browser (a visible browser in a split pane) for interactive, user-simulated verification, and the devtools MCP (headless Chromium) for console, network, performance traces, profiling, and screenshots. Use whenever the user wants anything verified, tested, clicked through, or debugged in a browser — "verify this", "test this in the browser", "click through", "simulate a user", "does it look right", "devtools", "screenshot", "why is it slow".
---

# Browser Verification & Debugging

Two browser tools with different experiences for the human: one is a shared
window they watch and can grab, the other an invisible instrument panel.

## Routing

| The ask                                                                                                                          | Tool                                                   |
| -------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| "Verify in a browser", "test this in the browser", "click through", "simulate a user", "check it looks right", "test end-to-end" | **agent-browser**                                      |
| "Debug", "console", "network requests", "performance trace", "profile", "screenshot", "devtools"                                 | **devtools MCP**                                       |
| Visual verification plus deep inspection                                                                                         | agent-browser first, then devtools MCP on the same URL |

The default for "verify in a browser" is **agent-browser** — the human asked
to watch or intervene. Devtools is for internals (console, network,
performance, screenshots). When ambiguous, prefer agent-browser: it costs
nothing, the human sees what happened, and you can follow up with devtools if
the visual pass surfaces something needing forensics.

## agent-browser (visible, interactive)

### Step 1 — open the browser

```bash
agent-browser localhost:3000              # split right by default
agent-browser localhost:3000 --place down # force split down
agent-browser report.html --no-merge      # isolated instance
```

### Step 2 — drive the browser

Act on the browser by key — this works whether you're in the pane that opened
it or in another pane or agent session:

```bash
agent-browser ls --all                            # find the browser key (looks like 19038-1)
agent-browser action --browser <key> -- snapshot  # element refs (@e14)
agent-browser action --browser <key> -- click @e35
agent-browser action --browser <key> -- fill @e3 "hello"
agent-browser action --browser <key> -- eval "document.title"
agent-browser action --browser <key> done         # clear the acting indicator
```

- `ls --all` sees every running browser; plain `ls` only sees browsers in the
  current terminal tab.
- `action` verbs: `snapshot`, `click @e14`, `fill @e3 "hello"`,
  `eval "document.title"`, plus CSS selectors (`click "#submit"`). Arguments
  go after `--`.
- After the last action, run `action done` so the acting indicator clears
  immediately instead of fading out.
- Leave the browser open when finished — the human may want to poke at it. In
  the Herdr GUI, close the pane with
  `herdr-app do terminal.kill '{"terminal":"tXX"}'` when asked; elsewhere it
  dies with the pane (ctrl+q).

### Practical gotchas

- Element refs (`@e7`) don't survive between CLI invocations — take a fresh
  `snapshot` per batch, and prefer CSS selectors when refs keep invalidating.
- agent-browser passes every non-open subcommand straight through to the
  terminal-browser CLI it wraps, so the full `terminal-browser --help`
  surface stays reachable.
- Herdr GUI: if the pane shows no rendering, check the terminal is alive with
  `hc get <terminal>`; if the browser died, reopen it. If rendering still fails
  (kitty graphics not passing through), say so — the visual pass didn't
  happen — and fall back to devtools MCP.

## devtools MCP (headless, forensic)

Headless Chromium — nothing on screen.
Console: `list_console_messages`.
Network: `list_network_requests`, `get_network_request_detail`.
Performance: `performance_start_trace`, `performance_stop_trace`, `performance_analyze_insight`.
Debugging: `evaluate_script`, `take_screenshot`, `take_snapshot`, `inspect_element`.
Input simulation without visual feedback: `click`, `fill`, `hover`, `drag`.

Prefer devtools over agent-browser for anything needing structured output —
screenshots, request/response bodies, console errors, trace flame charts.

Save screenshots under ~/Downloads.

## Combining them

For "verify this flow and debug why it's slow": run the visual flow in
agent-browser so the human can see and steer, then reproduce the specific
problem headlessly via devtools MCP for the trace or network detail.
