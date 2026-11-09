// Agents in grouped or priority views; parents take their most urgent sub-agent's place.
// A viewed done agent stays in Done until left.

import { View, div, image, svg } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { agents, terminals, panes, focused, spaces, run, theme, shared, setShared, setAgentOrder, openOverlay, closeOverlay, props, window, layout, nextCommand } from "herdr";

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}

// The sidebar's rail goes by its width, not a flag: dragging its edge narrows it too.
const narrow = () => (find(layout(), "sidebar")?.size?.px ?? Infinity) < 160;

// To the rail (on macOS wide enough for the traffic lights), or back to the width it had.
function toggleSidebar() {
  const width = find(layout(), "sidebar")?.size?.px;
  if (!narrow()) setShared("sidebar.width", width);
  // Mods edited before the rail went by width still read the flag.
  setShared("sidebar.collapsed", !narrow());
  run("layout.resize", { id: "sidebar", px: narrow() ? (shared("sidebar.width") ?? 268) : window()?.platform === "macos" ? 76 : 44 });
}

const clean = (s) => (s ?? "").replace(/^[^\p{L}\p{N}]+/u, "").trim();

function leadPanes(all) {
  const leads = new Map();
  for (const p of all) {
    if (!p.terminal) continue;
    const current = leads.get(p.tab);
    // First agent, else first focused terminal, else first terminal in the tab.
    if (!current || (!current.program?.agent && (p.program?.agent || (!current.focused && p.focused)))) leads.set(p.tab, p);
  }
  return leads;
}

function title(tab, l) {
  const prog = l?.program?.name;
  const live = clean(l?.title);
  const telling = live && live !== prog && !/^[~/]|^[A-Za-z]:\\/.test(live) && !live.includes("@") && live.toLowerCase() !== l?.program?.key;
  return (tab.name === prog || !tab.named) && telling ? live : tab.name;
}
const RANK = { blocked: 4, done: 3, working: 2, idle: 1 };
// A sub-agent without a pane isn't in agents(): its raw word, error counting as
// blocked. It's never done: it reports to its parent, and the parent's done is the news.
const kidStatus = (k, listed) => {
  const s = listed.get(k.address) ?? k.status;
  return s === "error" ? "blocked" : s === "done" ? "idle" : s;
};
const SORTS = [
  { id: "priority", label: "Priority", icon: "clock" },
  { id: "grouped", label: "Grouped by space", icon: "layers" },
];
const sortOf = () => SORTS.find((s) => s.id === shared("agents.sort")) ?? SORTS[0];
const SECTION = { 4: "Needs you", 3: "Done", 2: "Working", 1: "Idle" };
const SECTION_STATUS = { 4: "blocked", 3: "done", 2: "working" };

// The agent's icon from the app's program table: a one-color glyph or a picture.
function icon(p, size, color) {
  if (!p?.icon) return null;
  return p.tint ? svg(p.icon).size(size).flex_none().text_color(color) : image(p.icon).w(size).h(size).flex_none();
}

// Pixel art, drawn as blocks: Herdr won't load images or modules that resolve
// outside its folder, and this mod's files are symlinks into the dotfiles.
// Every grid is in 3px cells; each row's runs of one color become one block.
const CELL = 3;
const BASE = { O: "#16212b", S: "#1f3440", E: "#7fe3d8", e: "#3d7d78", B: "#f4f4f4", G: "#5b6b80" };

// Face rows are the screen's 8 inner cells; "|" in a body marks where they go.
const FACES = {
  working: ["SSSSSSSS", "SSESSESS", "SSESSESS", "SSSSSSSS"],
  idle: ["SSSSSSSS", "SSSSSSSS", "SeeSSeeS", "SSSSSSSS"],
  blocked: ["SSSSSSSS", "SBBSSBBS", "SBBSSBBS", "SSSEESSS"],
  done: ["SSSSSSSS", "SSESSESS", "SESSSSES", "SSEEEESS"],
};

const DESIGNS = [
  { // classic
    pal: { H: "#2c6e70", W: "#f2f2ee", C: "#cfc4a8", A: "#ffd36e", a: "#8a7a50" }, glow: "#fff3b0",
    body: [".....AA.....", ".....OO.....", ".OOOOOOOOOO.", "OWWWWWWWWWWO",
      "OW|WO", "OW|WO", "OW|WO", "OW|WO", "OCWWWWWWWWCO", ".OCCCCCCCCO.", "..OO....OO.."],
  },
  { // twin antennas
    pal: { H: "#6b4c9a", W: "#efeaf7", C: "#c9b8e0", A: "#ff8fb1", a: "#8a5a6a" }, glow: "#ffd1e0",
    body: [".AA......AA.", "..O......O..", ".OOOOOOOOOO.", "OWWWWWWWWWWO",
      "OW|WO", "OW|WO", "OW|WO", "OW|WO", "OCWWWWWWWWCO", ".OCCCCCCCCO.", "..OO....OO.."],
  },
  { // dome, hovering
    pal: { H: "#a0662c", W: "#f6efe2", C: "#e0c49a", A: "#ff6b5b", a: "#8a4a40" }, glow: "#ffc2b8",
    body: [".....AA.....", "...OOOOOO...", ".OOWWWWWWOO.", "OWWWWWWWWWWO",
      "OW|WO", "OW|WO", "OW|WO", "OW|WO", "OCWWWWWWWWCO", ".OCCCCCCCCO.", "...OOOOOO..."],
  },
  { // bent antenna, wheels
    pal: { H: "#3f7a3a", W: "#eef6ea", C: "#bfd8b0", A: "#c6f26b", a: "#6a7a40" }, glow: "#ecffc2",
    body: ["......AA....", ".....O......", ".OOOOOOOOOO.", "OWWWWWWWWWWO",
      "OW|WO", "OW|WO", "OW|WO", "OW|WO", "OCWWWWWWWWCO", "OOCCCCCCCCOO", ".OGO....OGO."],
  },
  { // ears
    pal: { H: "#2f5a9a", W: "#eaf0f8", C: "#b4c4dc", A: "#6fd0ff", a: "#40607a", K: "#ff9f43" }, glow: "#c8f0ff",
    body: ["......AA......", "......OO......", "..OOOOOOOOOO..", ".OWWWWWWWWWWO.",
      ".OW|WO.", "KOW|WOK", "KOW|WOK", ".OW|WO.", ".OCWWWWWWWWCO.", "..OCCCCCCCCO..", "...OO....OO..."],
  },
  { // capped, jet flame
    pal: { H: "#8a3a5a", W: "#f7ecef", C: "#dcb4c0", A: "#ffe066", a: "#8a7a40", F: "#ff7a3a", f: "#ffd23a" }, glow: "#fff6c0",
    body: [".....AA.....", "....OOOO....", ".OOOOOOOOOO.", "OWWWWWWWWWWO",
      "OW|WO", "OW|WO", "OW|WO", "OW|WO", "OCWWWWWWWWCO", ".OCCCCCCCCO.", "....FffF...."],
  },
];

// A one-cell ring around the sprite, like the reference ghosts.
function halo(grid) {
  const w = grid[0].length + 2, h = grid.length + 2;
  const g = Array.from({ length: h }, (_, y) => Array.from({ length: w }, (_, x) => grid[y - 1]?.[x - 1] ?? "."));
  const solid = (x, y) => g[y]?.[x] && g[y][x] !== "." && g[y][x] !== "H";
  for (let y = 0; y < h; y++) for (let x = 0; x < w; x++)
    if (g[y][x] === "." && (solid(x - 1, y) || solid(x + 1, y) || solid(x, y - 1) || solid(x, y + 1))) g[y][x] = "H";
  return g.map((r) => r.join(""));
}

function runs(grid, pal) {
  const out = [];
  grid.forEach((row, y) => {
    for (let x = 0; x < row.length;) {
      let end = x + 1;
      while (end < row.length && row[end] === row[x]) end++;
      if (pal[row[x]]) out.push([x, y, end - x, pal[row[x]]]);
      x = end;
    }
  });
  return out;
}

const BOTS = DESIGNS.map((d) => {
  const faces = {};
  for (const [name, face] of Object.entries(FACES)) {
    let n = 0;
    const tip = name === "idle" ? "a" : "A";
    const core = d.body.map((r) => (r.includes("|") ? r.replace("|", face[n++]) : r).replaceAll("A", tip));
    faces[name] = runs(halo(core), { ...BASE, ...d.pal });
  }
  const g = halo(d.body.map((r) => r.replace("|", "SSSSSSSS")));
  const tips = [];
  g.forEach((r, y) => [...r].forEach((c, x) => { if (c === "A" && r[x - 1] !== "A") tips.push([x, y]); }));
  return { cols: g[0].length, rows: g.length, faces, tips, glow: d.glow };
});

const SKY = ["#121a25", "#141e2b", "#162231", "#182638", "#1a2a3e", "#1c2e44", "#1e324a", "#203650"];
const SCENE = [
  ...SKY.map((c, i) => [0, i * 2, 18, c, 2]),
  ...runs([
    "..................",
    ".MM...........s...",
    "MM......s.........",
    "MM................",
    ".MM.........s.....",
    "..................",
    "....s.............",
    "..................",
    "...............s..",
    "..................",
    ".s................",
    "..................",
    "................s.",
    "..................",
    "..................",
    "..................",
    "GgGGGGgGGGGGgGGGGg",
    "DDDDDDDDDDDDDDDDDD",
  ], { M: "#e9e4cf", s: "#5b6b80", G: "#2d5a4c", g: "#3c7562", D: "#213f37" }),
];
const QUESTION = runs([".XX.", "X..X", "..X.", ".X..", "....", ".X.."], { X: "X" });
const SPARKLE = runs([".X.", "XXX", ".X."], { X: "X" });

// Blocks for runs [x, y, width, color, height?], placed inside a relative or absolute parent.
const blocks = (list, color) => list.map(([x, y, w, c, h = 1]) =>
  div().absolute().left(x * CELL).top(y * CELL).w(w * CELL).h(h * CELL).bg(color ?? c));

const scene = () => blocks(SCENE);
const sprite = (look, face) => blocks(BOTS[look].faces[face]);
const question = (color) => div().absolute().w(4 * CELL).h(6 * CELL).children(blocks(QUESTION, color));
const sparkle = (color) => div().absolute().size(3 * CELL).children(blocks(SPARKLE, color));

// The scene is an 18×18 grid of 3px cells; positions below are in px.
const TWINKLES = [[48, 9, 1300], [30, 3, 1900], [3, 27, 2300]];
const SPARKLES = [[39, 0, 900], [12, 0, 1300], [45, 21, 1100]];

function bot(status, look) {
  const t = theme();
  const face = ["working", "idle", "blocked", "done"].includes(status) ? status : "idle";
  const working = status === "working";
  const { cols, rows, tips, glow } = BOTS[look];
  const body = div().absolute().left(Math.floor((18 - cols) / 2) * 3).top(9).w(cols * 3).h(rows * 3)
    .when(working, (el) => el.loop("top", { from: 9, to: 6, period: 1400 }))
    .children(sprite(look, face))
    .when(working, (el) => el.children(tips.map(([x, y]) => div().absolute().left(x * 3).top(y * 3).w(6).h(3).bg(glow)
      .loop("opacity", { from: 0, to: 1, period: 900 }))));
  return div().relative().size(54).flex_none().rounded(6).overflow_hidden()
    .children(scene())
    .when(working, (el) => el.children(TWINKLES.map(([x, y, period]) =>
      div().absolute().left(x).top(y).size(3).bg("#ffffff").loop("opacity", { from: 0.1, to: 1, period }))))
    .when(status === "idle", (el) => el.child(div().absolute().inset_0().bg("#0b0f1580")))
    .child(body)
    .when(status === "done", (el) => el.children(SPARKLES.map(([x, y, period]) =>
      sparkle("#ffffff").left(x).top(y).loop("opacity", { from: 0.2, to: 1, period }))))
    .when(status === "blocked", (el) => el.child(question(t.blocked).left(42).top(0)
      .loop("top", { from: 0, to: 3, period: 1000 })));
}

export default class Agents extends View {
  init(_props, cx) {
    if (props()?.sortMenu) return;
    this.folded = new Set();
    // Each agent's last state and when it changed (ms), kept across restarts.
    this.changed = JSON.parse(localStorage.getItem("changed") ?? "{}");
    this.pendingPins = JSON.parse(localStorage.getItem("pins") ?? "[]");
    if (!this.pendingPins.length) localStorage.removeItem("pins");
    this.migratingPins = new Set();
    this.looks = JSON.parse(localStorage.getItem("looks") ?? '{"next":0,"of":{}}');
    cx.timer.every(30000, (cx) => cx.notify());
    // Numbered keys (agents-plus.focus:N) focus the Nth row: same order as the list.
    cx.spawn(async (cx) => {
      for (;;) {
        const c = await nextCommand();
        const m = /^focus\b[:\s]*(\d*)$/.exec(c);
        if (!m) continue;
        const addr = this.ordered?.[Number(m[1]) - 1];
        if (addr) run("agent.focus", { terminal: addr });
        cx.notify();
      }
    });
  }

  // Stamps agents whose state changed. Done and idle count as one: looking at a
  // finished agent turns done into idle, and looking isn't the agent doing anything.
  track(list, now) {
    let dirty = false;
    for (const a of list) {
      const s = a.status === "done" ? "idle" : a.status;
      if (this.changed[a.address]?.s === s) continue;
      this.changed[a.address] = { s, at: now };
      dirty = true;
    }
    if (!dirty) return;
    // Gone and old: the list alone is empty right after a start.
    const listed = new Set(list.map((a) => a.address));
    for (const [k, c] of Object.entries(this.changed)) if (!listed.has(k) && now - c.at > 30 * 86400000) delete this.changed[k];
    localStorage.setItem("changed", JSON.stringify(this.changed));
  }

  // New agents take the next bot design in turn; forgotten along with their state stamps.
  assignLooks(list) {
    const { of } = this.looks;
    if (list.every((a) => a.address in of)) return;
    for (const a of list) if (!(a.address in of)) of[a.address] = this.looks.next++ % BOTS.length;
    for (const k of Object.keys(of)) if (!(k in this.changed)) delete of[k];
    localStorage.setItem("looks", JSON.stringify(this.looks));
  }

  // Keep offline pins until their terminal returns, and keep each pending until
  // core echoes the label so a failed write doesn't erase the old pin.
  migratePins(all) {
    const listed = new Map(all.filter((t) => t.state === "live").map((t) => [t.address, t]));
    const pending = this.pendingPins.filter((address) => {
      const terminal = listed.get(address);
      if (!terminal) return true;
      if (terminal.labels?.["herdr.pinned"]) return false;
      if (!this.migratingPins.has(address)) {
        this.migratingPins.add(address);
        run("terminal.pin", { terminal: address, pinned: true });
      }
      return true;
    });
    if (pending.length === this.pendingPins.length) return;
    this.pendingPins = pending;
    if (pending.length) localStorage.setItem("pins", JSON.stringify(pending));
    else localStorage.removeItem("pins");
  }

  since(a) {
    return this.changed[a.address]?.at ?? 0;
  }

  // Looking at a done agent makes it idle; it stays with Done until you leave
  // it rather than drop away under you. Any other change moves it at once.
  hold(list) {
    const cur = list.find((a) => a.focused);
    const same = cur && cur.address === this.held?.address;
    // Arriving, or any change but done turning idle, sets what it was.
    if (!same || cur.status !== "idle") this.held = cur ? { address: cur.address, rank: RANK[cur.status] ?? 0 } : null;
  }

  rank(a) {
    const sawDone = a.address === this.held?.address && this.held.rank === RANK.done && a.status === "idle";
    return sawDone ? RANK.done : RANK[a.status] ?? 0;
  }

  sortMenu(t) {
    const on = sortOf().id;
    return v_flex()
      .w_full()
      .p(5)
      .bg(t.popover)
      .text_size(12.8)
      .child(div().px(8).pt(4).pb(6).text_size(11).text_color(t.dim).child("Sort agents"))
      .children(SORTS.map((s) => h_flex()
        .id(`sort-${s.id}`)
        .h(31)
        .px(8)
        .gap(9)
        .rounded(7)
        .items_center()
        .text_color(t.foreground)
        .hover((el) => el.bg(t.hover))
        .on_click(() => {
          setShared("agents.sort", s.id);
          closeOverlay(props().overlay);
        })
        .child(svg(`mods/workspace-chrome/${s.icon}.svg`).size(14).flex_none().text_color(t.muted))
        .child(div().flex_1().child(s.label))
        .when(s.id === on, (el) => el.child(svg("mods/workspace-chrome/check.svg").size(14).flex_none().text_color(t.foreground)))));
  }

  peek(addr) {
    run("terminal.peek", { terminal: addr });
  }

  // Live sub-agents of `addr`, depth first, each with the tree lines in front of it.
  tree(all, addr, lead = []) {
    const kids = all.filter((k) => k.parent === addr && k.state === "live");
    return kids.flatMap((k, i) => {
      const last = i === kids.length - 1;
      return [
        { t: k, lines: [...lead, last ? "└" : "├"] },
        ...this.tree(all, k.address, [...lead, last ? "" : "│"]),
      ];
    });
  }

  subRow(t, s, shown, compact) {
    const k = s.t;
    const st = kidStatus(k, this.listed);
    const pic = icon(k.program, 14, t.foreground);
    const on = k.address === shown;
    return h_flex()
      .id(`sub-${k.address}`)
      .pl(39)
      .pr(8)
      .rounded(8)
      .h(26)
      .flex_none()
      .gap(0)
      .items_center()
      .text_size(12.5)
      .when(on, (el) => el.bg(t.raised))
      .hover((s) => s.bg(t.hover))
      .on_click(() => this.peek(k.address))
      .children(s.lines.map(l => div().self_start().mt(-4).w(9).h(17).mr(4).flex_none()
        .when(Boolean(l), el => el.border_l(1.5).border_color(t.input))
        .when(l === "└" || l === "├", el => el.border_b(1.5).rounded_bl(6))))
      .when(Boolean(pic), el => el.child(div().mr(8).child(pic)))
      .child(div().flex_1().truncate().text_color(on ? t.foreground : t.muted).child(k.name || k.template || k.program?.name || k.address))
      .child(this.status(t, { status: st }, compact));
  }

  // compact: a ! for blocked where a header already says "Needs you".
  status(t, a, compact = false) {
    const color = t[a.status] ?? t.dim;
    if (a.status === "working") return svg("mods/workspace-chrome/spinner.svg").size(12).mx(1).flex_none().text_color(t.working).spin(900);
    if (a.status === "blocked" && compact) return div().size(14).flex_none().rounded(4).bg(t.blocked + "26").text_size(10.5).font_bold().text_color(t.blocked).flex().items_center().justify_center().child("!");
    if (a.status === "blocked") return div().flex_none().px(6).h(18).rounded(5).bg(t.blocked + "26").text_size(10.5).font_semibold().text_color(t.blocked).flex().items_center().child("Needs you");
    // Idle: a ring; done: a dot.
    if (a.status === "idle") return div().size(7).mx(3).flex_none().rounded(4).border(1.5).border_color(t.idle ?? t.dim);
    return div().size(7).mx(3).flex_none().rounded(4).bg(a.status === "done" ? color : t.dim + "00");
  }

  render(cx) {
    const t = theme();
    if (props()?.sortMenu) return this.sortMenu(t);
    const collapsed = narrow();
    const sort = sortOf();
    let list = agents();
    this.listed = new Map(list.map((a) => [a.address, a.status]));
    const all = terminals();
    this.migratePins(all);
    const shown = focused()?.agent;
    const now = Date.now();
    this.track(list, now);
    this.assignLooks(list);
    this.hold(list);
    const byPriority = sort.id === "priority";
    const urgency = new Map(list.map((a) => [a.address, Math.max(this.rank(a), ...this.tree(all, a.address).map((s) => RANK[kidStatus(s.t, this.listed)] ?? 0))]));
    const rankOf = (a) => urgency.get(a.address);
    if (byPriority) list = [...list].sort((x, y) => rankOf(y) - rankOf(x) || this.since(y) - this.since(x) || y.seq - x.seq);
    const pinned = list.filter((a) => a.pinned);
    const rest = list.filter((a) => !a.pinned);
    list = [...pinned, ...rest];
    const order = list.map((a) => a.address);
    setAgentOrder(order);
    this.ordered = order;

    const withKids = (a, i) => {
      const subs = collapsed ? [] : this.tree(all, a.address);
      const r = row(a, i, subs);
      if (this.folded.has(a.address)) return [r];
      return [r, ...subs.map((s) => this.subRow(t, s, shown, byPriority))];
    };

    // The fold chevron; folded, the count too, colored by the most urgent one.
    const fold = (a, subs) => {
      const sts = subs.map((s) => kidStatus(s.t, this.listed));
      const top = sts.reduce((m, s) => ((RANK[s] ?? 0) > (RANK[m] ?? 0) ? s : m), null);
      const open = !this.folded.has(a.address);
      return div()
        .id(`fold-${a.address}`)
        .h(18)
        .px(3)
        .gap(3)
        .flex()
        .items_center()
        .rounded(4)
        .text_size(11)
        .text_color(open ? t.dim : (t[top] ?? t.dim))
        .cursor_pointer()
        .hover((s) => s.bg(t.hover).text_color(t.foreground))
        .on_click((_e, cx) => {
          cx.stop_propagation();
          open ? this.folded.add(a.address) : this.folded.delete(a.address);
          cx.notify();
        })
        .child(svg(`mods/workspace-chrome/chevron-${open ? "down" : "right"}.svg`).size(11).flex_none())
        .when(!open, (el) => el.child(String(subs.length)));
    };

    // Read the pane snapshot once: every host read copies the whole list into JS.
    const leads = leadPanes(panes());
    const tabLabels = new Map(spaces().flatMap(s => s.tabs).map(tab => [tab.id, title(tab, leads.get(tab.id))]));
    const labels = new Map(list.map(a => [a.address, tabLabels.get(a.tab) ?? (a.title || a.program?.name || "")]));
    const label = (a) => labels.get(a.address);

    const row = (a, i, subs = []) => {
      const pic = icon(a.program, 12, t.dim);
      // An agent on another machine (`vps/t7`) says which.
      const machine = a.address.includes("/") ? a.address.split("/")[0] : null;
      if (collapsed) {
        return h_flex()
          .id(`ag-${a.address}`)
          .h(26)
          .px(8)
          .flex_none()
          .items_center()
          .gap(4)
          .hover((s) => s.bg(t.hover))
          .on_click(() => run("pane.focus", { pane: a.pane }))
          .child(div().flex_1().min_w(0).whitespace_nowrap().text_right().text_color(t.muted).child(String(i + 1)))
          .child(h_flex().w(14).flex_none().items_center().justify_center().child(this.status(t, a, true)));
      }
      const idle = a.status === "idle" && !a.focused;
      const isPinned = a.pinned;
      const pin = div()
        .id(`pin-${a.address}`)
        .flex_none()
        .p(2)
        .rounded(4)
        .text_color(t.dim)
        .cursor_pointer()
        .hover((s) => s.bg(t.hover).text_color(t.foreground))
        .tooltip(isPinned ? "Unpin" : "Pin to the top")
        .on_click((_e, cx) => {
          cx.stop_propagation();
          run("terminal.pin", { terminal: a.address, pinned: !isPinned });
          // The row moves away from under the pointer, and no hover-out comes.
          this.hovered = null;
          cx.notify();
        })
        .child(svg(`mods/workspace-chrome/${isPinned ? "pin-off" : "pin"}.svg`).size(13));
      const named = /^\d+$/.test(label(a)) ? clean(a.title) || a.program?.name || label(a) : label(a);
      // OpenCode prefixes every session title with "OC | ".
      const session = named.replace(/^OC \| /, "");
      const statusColor = a.status === "idle" ? t.dim : t[a.status] ?? t.dim;
      return h_flex()
        .id(`ag-${a.address}`)
        .p(6)
        .mb(6)
        .flex_none()
        .rounded(10)
        .items_center()
        .gap(10)
        .bg(t.background)
        .border(1)
        .border_color(a.focused ? t.accent : t.border)
        .cursor_pointer()
        .hover((s) => s.bg(t.hover))
        .on_hover((on, cx) => {
          if (on) this.hovered = a.address;
          else if (this.hovered === a.address) this.hovered = null;
          cx.notify();
        })
        .on_click(() => run("pane.focus", { pane: a.pane }))
        .child(bot(a.status, this.looks.of[a.address] ?? 0))
        .child(v_flex().flex_1().min_w(0).gap(2)
          .child(h_flex().gap(5).items_center().text_size(11).text_color(t.dim)
            .when(Boolean(pic), el => el.child(div().id(`agent-fold-${a.address}`)
              .when(subs.length > 0, el => el.on_click((_e, cx) => {
                cx.stop_propagation();
                this.folded.has(a.address) ? this.folded.delete(a.address) : this.folded.add(a.address);
                cx.notify();
              })).child(pic)))
            .child(div().flex_1().min_w(0).truncate().child(a.program?.name ?? a.app ?? "agent"))
            .when(this.hovered === a.address, el => el.child(pin)))
          .child(h_flex().gap(5).items_center()
            .child(div().flex_1().min_w(0).truncate().text_size(13).font_medium().text_color(idle ? t.muted : t.foreground).child(session))
            .when(subs.length > 0, el => el.child(fold(a, subs))))
          .child(h_flex().gap(5).items_center().text_size(11).text_color(t.dim)
            .child(div().flex_none().text_color(statusColor).child(a.status))
            .child(div().flex_none().child("\u00b7"))
            .child(div().min_w(0).truncate().child(a.space_name || ""))
            .when(Boolean(machine), el => el.child(div().flex_none().text_size(10).child(machine)))));
    };

    // Groups in list order: spaces (grouped) or priority sections. Agents of a
    // space are next to each other in agents(), so neighbours make a group.
    const groups = pinned.length ? [{ id: "pinned", label: "Pinned", status: null, members: pinned }] : [];
    for (const a of rest) {
      const r = rankOf(a) || RANK.idle;
      const id = byPriority ? `sec-${r}` : `sp-${a.space}`;
      if (groups.at(-1)?.id === id) groups.at(-1).members.push(a);
      else groups.push({ id, label: byPriority ? SECTION[r] : a.space_name || "", status: byPriority ? SECTION_STATUS[r] : null, members: [a] });
    }

    // A group's header; it folds the group. Folded, it says how many and the most urgent state.
    const header = (g) => {
      const open = !this.folded.has(g.id);
      const top = g.members.reduce((m, a) => ((RANK[a.status] ?? 0) > (RANK[m] ?? 0) ? a.status : m), null);
      return h_flex()
        .id(g.id)
        .px(8)
        .pt(8)
        .h(30)
        .flex_none()
        .gap(6)
        .items_center()
        .text_size(11)
        .font_medium()
        .cursor_pointer()
        .hover((s) => s.text_color(t.foreground))
        .on_click((_e, cx) => {
          open ? this.folded.add(g.id) : this.folded.delete(g.id);
          cx.notify();
        })
        .child(div().truncate().text_color(t[g.status] ?? t.dim).child(g.label))
        .when(byPriority || !open, (el) => el.child(div().text_color(t.dim).child(String(g.members.length))))
        .child(div().flex_1())
        .when(!open, (el) => el
          .when(!byPriority && top && top !== "idle", (el) => el.child(this.status(t, { status: top }, true)))
          .child(svg("mods/workspace-chrome/chevron-right.svg").size(11).flex_none().text_color(t.dim)));
    };
    const rows = collapsed
      ? list.flatMap(withKids)
      : groups.flatMap((g) => [header(g), ...(this.folded.has(g.id) ? [] : g.members.flatMap(withKids))]);

    return v_flex()
      .size_full()
      .min_h(0)
      .bg(t.chrome)
      .border_t(1)
      .border_color(t.border)
      .text_size(13)
      .when(!collapsed, (el) =>
        el.child(
          h_flex()
            .px(16)
            .h(41)
            .pt(14)
            .pb(5)
            .flex_none()
            .items_center()
            .justify_between()
            .child(div().text_size(11.5).font_medium().text_color(t.dim).child("Agents"))
            .child(
              div()
                .id("ag-sort")
                .text_size(11)
                .text_color(t.dim)
                .hover((s) => s.text_color(t.foreground))
                .on_click(() => openOverlay({ mod: "agents-plus", kind: "popup", width: 200, height: 140, props: { sortMenu: true } }))
                .tooltip(`Sort agents: ${sort.label}`)
                .child(svg(`mods/workspace-chrome/${sort.icon}.svg`).size(14)),
            ),
        ),
      )
      .when(list.length === 0 && !collapsed, (el) =>
        el.child(div().px(12).text_size(12).text_color(t.dim).child("No agent status yet. Agents show up here when they report their status. Older versions and agents inside tmux may not.")),
      )
      .child(v_flex().id("ag-list").flex_1().min_h(0).px(collapsed ? 0 : 8).overflow_y_scrollbar().mode("always").children(rows))
      .when(collapsed, (el) =>
        el.child(
          h_flex()
            .h(28)
            .items_center()
            .justify_center()
            .child(
              div()
                .id("collapse")
                .text_size(13)
                .text_color(t.dim)
                .hover((s) => s.text_color(t.foreground))
                .on_click(toggleSidebar)
                .child("»"),
            ),
        ),
      );
  }
}
