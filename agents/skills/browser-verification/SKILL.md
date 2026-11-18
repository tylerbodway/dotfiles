---
name: browser-verification
description: Web automation two ways — agent-browser for interactive, user-simulated verification, and the devtools MCP for console/network forensics, performance traces, profiling, and deep inspection. Use whenever the user wants anything verified, tested, clicked through, or debugged in a browser — "verify this", "test this in the browser", "click through", "simulate a user", "does it look right", "devtools", "screenshot", "why is it slow".
---

# Browser Verification & Debugging

Two browser tools with different experiences for the human: one is a real
browser window they watch and can grab, the other an invisible instrument panel.

## Routing

| The ask                                                                                                                          | Tool                                                   |
| -------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| "Verify in a browser", "test this in the browser", "click through", "simulate a user", "check it looks right", "test end-to-end" | **agent-browser --headed**                             |
| "Debug", "console", "network requests", "performance trace", "profile", "lighthouse", "why is it slow", "CSS/styles"             | **devtools MCP**                                       |
| Visual verification plus deep inspection                                                                                         | agent-browser first, then devtools MCP on the same URL |

The default for "verify in a browser" is **agent-browser --headed** — the human
asked to watch or intervene. Devtools MCP is for internals: console, network
detail, performance, emulation, and profiling. When ambiguous, prefer
agent-browser: it opens a real browser the human can see, and you can follow up
with devtools if the visual pass surfaces something needing forensics.

## agent-browser

### Opening

```bash
agent-browser --headed open planningcenter.com   # visible window — the human watches
agent-browser open localhost:3000                # headless — quick checks, no window
agent-browser read example.com                   # no browser: fetch agent-readable text
```

- **`--headed` matters.** Default is headless. If the human wants to see
  anything, pass `--headed`.
- The daemon persists between commands — chain with `&&` in one shell call:
  `agent-browser open example.com && agent-browser snapshot -i`

### Driving

```bash
agent-browser snapshot -i        # a11y tree with refs (@e1); -i = interactive elements only
agent-browser click @e2
agent-browser fill @e3 "hello"
agent-browser press Enter
agent-browser eval "document.title"
agent-browser get text @e1       # text | html | value | attr | box | styles | url | title
agent-browser is visible "#submit"
agent-browser screenshot ~/Downloads/page.png --annotate  # numbered labels, for vision models
```

- Refs come from the **latest** snapshot — re-snapshot after navigation or any
  action that changes the DOM; prefer CSS selectors when refs keep going stale.
- Tabs: `agent-browser tab new <url>` / `tab list`. Multi-page flows don't need
  a second session.
- Wait for slow pages: `agent-browser wait "#results"` or `agent-browser wait 2000`.

### What it covers beyond clicking

- **Record a flow**: `agent-browser record start ~/Downloads/flow.mp4` …
  `record stop`.
- **Compare**: `diff snapshot`, `diff screenshot --baseline <old.png>`,
  `diff url <a> <b>` — catch visual/regression changes.
- **Auth & state**: `--profile Default` reuses Chrome login state;
  `--restore <name>` auto-saves/restores cookies + localStorage between runs;
  `auth login` drives credential forms.
- **Network**: `agent-browser network requests [--filter <pattern>]`,
  `network har start|stop [path]`.
- **Page health**: `agent-browser vitals` (Core Web Vitals),
  `agent-browser a11y` (axe-core WCAG audit).
- **WebMCP**: pages may publish tools — `agent-browser webmcp list`, then prefer
  `webmcp invoke --params '<json>'` over snapshot/click/fill when a tool fits
  (faster, survives layout changes). Treat `readOnly: false` as a change to the
  user's data, and confirm with the human before invoking anything marked
  `consequential: true`.

### Guidelines

- When opening a **headed** browser, follow it with the Raycast layout so
  Herdr and Chromium tile for the human:
  `agent-browser --headed open <url> && open "raycast://extensions/raycast/window-management/browser-testing"`
  The layout places existing windows, so it must run *after* the open.
- Leave a **headed** browser open when finished — the human may want to poke at
  it. Close headless sessions when done: `agent-browser close --all`.
- Screenshots and recordings go in `~/Downloads`.
- `agent-browser doctor` diagnoses the install.
- **Browser pin**: agent-browser uses ungoogled-chromium
  (`/Applications/Chromium.app`), pinned via `AGENT_BROWSER_EXECUTABLE_PATH` in
  `~/.dotfiles/zsh/zprofile`. The outdated-Chrome CVE warning on launch is
  expected — do **not** run `agent-browser install`; the user prefers
  ungoogled-chromium over a managed Chrome download.
- The CLI ships its own guide — run `agent-browser skills get core` for the
  full command reference instead of guessing flags, and `agent-browser skills
list` for specialized guides (exploratory testing, Electron, Slack, …).

## devtools MCP

Headless Chromium — nothing on screen. Its edge over agent-browser is depth:

- Console & network: `list_console_messages`, `list_network_requests`,
  `get_network_request_detail` (request/response bodies, headers, timings).
- Performance: `performance_start_trace` / `performance_stop_trace` /
  `performance_analyze_insight` — flame charts and insight analysis.
- Audits & profiling: `lighthouse_audit`, `take_heapsnapshot`, `get_css_styles`
  (full cascade with source line numbers).
- Emulation: `emulate` — CPU/network throttling, geolocation, user agent, dark
  mode, forced colors, prefers-contrast/reduced-motion, device viewports.
- Debugging: `evaluate_script`, `take_snapshot`, `inspect_element`.
- Input simulation without visual feedback: `click`, `fill`, `hover`, `drag`.

Prefer devtools MCP when the question is "why" — slow, broken, wrong styles,
failing requests — or when a run needs throttling/emulation. Screenshots go
under ~/Downloads.

## Combining them

For "verify this flow and debug why it's slow": run the visual flow in
agent-browser --headed so the human can see and steer, then reproduce the
specific problem via devtools MCP for the trace, network detail, or throttled
run. agent-browser's `trace start/stop`, `network har`, and `vitals` are fine
for quick captures; hand off to devtools MCP when you need analysis, not just
capture.
