// New space in a folder you pick. Sibling of "new space" (cmd+n): instead of
// opening in the current folder, this opens a centered dialog with a search
// field. Type to search folders under ~ (recents first), or type a path —
// "Code/acme/app", "~/src/app", "/opt/other" — to browse it directly.
// ↑/↓ and Enter open a space in the folder, Esc closes. Recents are the
// folders picked here, kept in shared "space-picker.recents"; until the first
// pick, the folders of your open spaces stand in.

import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { home, props, closeOverlay, run, shared, setShared, spaces, theme } from "herdr";
import * as fs from "fs/promises";

const KEY = "space-picker.recents";
// System folders a code folder never hides under.
const SKIP = new Set(["Library", "Applications", "Movies", "Music", "Pictures", "Public", "node_modules"]);
const MAX_MATCHES = 40;
const WALK_DEPTH = 3;
const WALK_LIMIT = 3000;

async function listDirs(dir, hidden) {
  let entries;
  try {
    entries = await fs.readdir(dir, { withFileTypes: true });
  } catch {
    return null;
  }
  const names = entries
    .filter((e) => e.isDirectory() && (hidden || !e.name.startsWith(".")) && !SKIP.has(e.name))
    .map((e) => e.name);
  names.sort((a, b) => a.localeCompare(b));
  return names;
}

async function walk(dir, depth, index) {
  if (depth === 0 || index.length >= WALK_LIMIT) return;
  const names = await listDirs(dir, false);
  if (!names) return;
  for (const name of names) {
    const path = `${dir}/${name}`;
    index.push({ name, path });
    await walk(path, depth - 1, index);
  }
}

const tilde = (p) => (p === home() ? "~" : p.startsWith(home() + "/") ? "~" + p.slice(home().length) : p);

export default class SpacePicker extends View {
  init(_props, cx) {
    this.input = InputState.new({ placeholder: "Search folders, or type a path (~/Code, /opt)…" });
    this.filter = "";
    this.at = 0;
    this.index = null; // every folder under ~, a few deep, built once per open
    this.dirCache = {}; // absolute dir → its folder names (null: unreadable)
    this.pending = new Set();
    this.indexStarted = false;
    this.closed = false;
    this.handle = cx.focus_handle();
    this.input.on("change", (_e, cx) => {
      this.filter = this.input.value();
      this.at = 0;
      this.load(cx);
      cx.notify();
    });
    this.input.on("submit", () => this.pick(this.pickable()[this.at]));
    this.input.focus();
    cx.timer.after(600, () => {
      if (!this.closed) this.input.focus();
    });
    this.load(cx);
  }

  close() {
    if (this.closed) return;
    this.closed = true;
    closeOverlay(props().overlay);
  }

  recents() {
    const kept = shared(KEY);
    if (Array.isArray(kept) && kept.length) return kept;
    const seen = new Set();
    return spaces()
      .map((s) => s.folder)
      .filter((f) => f && f !== home() && !seen.has(f) && seen.add(f))
      .slice(0, 5);
  }

  // The folder the filter browses ("Code/acme" → ~/Code/acme, "~/src" →
  // ~/src, "/opt" → /opt), with the piece after its last "/" as the prefix,
  // or null when the filter is a plain search.
  parsePath(q) {
    if (!q.includes("/")) return null;
    const slash = q.lastIndexOf("/");
    const head = q.slice(0, slash);
    const prefix = q.slice(slash + 1).toLowerCase();
    const dir = q.startsWith("/")
      ? head || "/"
      : q.startsWith("~")
        ? home() + head.slice(1)
        : `${home()}/${head}`;
    return { dir, prefix };
  }

  load(cx) {
    const q = this.filter.trim();
    const path = this.parsePath(q);
    // A typed path segment starting with "." asks for hidden folders
    // (".dotfiles" matches ~/.dotfiles); the plain listing never shows them.
    const hidden = !!path && path.prefix.startsWith(".");
    const dir = path ? path.dir : home();
    const key = dir + (hidden ? "\u0000" : "");
    if (this.dirCache[key] === undefined && !this.pending.has(key)) {
      this.pending.add(key);
      cx.spawn(async (cx) => {
        this.dirCache[key] = await listDirs(dir, hidden);
        this.pending.delete(key);
        cx.notify();
      });
    }
    if (!path && !this.indexStarted) {
      this.indexStarted = true;
      cx.spawn(async (cx) => {
        const index = [];
        await walk(home(), WALK_DEPTH, index);
        this.index = index;
        cx.notify();
      });
    }
  }

  // Rows to show, with section heads. "dir" rows pick a folder, "here" picks
  // the browsed one, "note" rows only say something.
  rows() {
    const q = this.filter.trim();
    const path = this.parsePath(q);
    const out = [];
    if (path) {
      const names = this.dirCache[path.dir + (path.prefix.startsWith(".") ? "\u0000" : "")];
      if (names === undefined) return [{ kind: "note", text: "Searching…" }];
      if (names === null) return [{ kind: "note", text: `Can't read ${tilde(path.dir)}` }];
      out.push({ kind: "here", dir: path.dir });
      for (const name of names)
        if (name.toLowerCase().startsWith(path.prefix)) out.push({ kind: "dir", name, path: `${path.dir}/${name}` });
      return out;
    }
    const recents = this.recents().filter((p) => !q || p.toLowerCase().includes(q));
    if (recents.length) {
      out.push({ kind: "head", text: "Recents" });
      for (const p of recents) out.push({ kind: "dir", name: p.split("/").pop(), path: p });
    }
    const names = this.dirCache[home()];
    if (!q) {
      if (names) {
        out.push({ kind: "head", text: `Folders in ~` });
        for (const name of names) out.push({ kind: "dir", name, path: `${home()}/${name}` });
      }
      return out;
    }
    if (!this.index) return [{ kind: "note", text: "Searching…" }];
    out.push({ kind: "head", text: "Folders" });
    const starts = [];
    const words = [];
    const paths = [];
    for (const e of this.index) {
      const n = e.name.toLowerCase();
      if (n.startsWith(q)) starts.push(e);
      else if (n.includes(q)) words.push(e);
      else if (e.path.toLowerCase().includes(q)) paths.push(e);
    }
    const matches = [...starts, ...words, ...paths].slice(0, MAX_MATCHES);
    if (!matches.length) return [{ kind: "note", text: "No folders match" }];
    for (const e of matches) out.push({ kind: "dir", name: e.name, path: e.path });
    return out;
  }

  pickable() {
    return this.rows().filter((r) => r.kind === "dir" || r.kind === "here");
  }

  pick(row) {
    if (!row) return;
    const folder = row.kind === "here" ? row.dir : row.path;
    const kept = Array.isArray(shared(KEY)) ? shared(KEY).filter((p) => p !== folder) : [];
    setShared(KEY, [folder, ...kept].slice(0, 6));
    this.close();
    run("space.new", { folder, machine: "" });
  }

  render() {
    const t = theme();
    const rows = this.rows();
    const pickable = rows.filter((r) => r.kind === "dir" || r.kind === "here");
    this.at = Math.max(0, Math.min(this.at, pickable.length - 1));
    const sel = pickable[this.at];
    const row = (r) => {
      if (r.kind === "head")
        return h_flex()
          .px(10)
          .pt(8)
          .pb(2)
          .text_size(11)
          .font_semibold()
          .text_color(t.dim)
          .child(r.text);
      if (r.kind === "note")
        return h_flex().px(10).py(6).text_size(12).text_color(t.dim).child(r.text);
      const on = r === sel;
      const here = r.kind === "here";
      return h_flex()
        .id(`sp-${here ? "here" : r.path}`)
        .mx(4)
        .px(10)
        .h(30)
        .items_center()
        .gap(8)
        .rounded(7)
        .cursor_pointer()
        .when(on, (el) => el.bg(t.hover))
        .hover((s) => s.bg(t.hover))
        .on_click(() => this.pick(r))
        .child(div().text_color(t.accent).child(here ? "›" : "□"))
        .child(
          here
            ? div().flex_1().truncate().text_color(t.foreground).child(`New space in ${tilde(r.dir)}`)
            : div().flex_1().truncate().text_color(t.foreground).child(r.name),
        )
        .when(!here, (el) => el.child(div().truncate().max_w(220).text_size(11).text_color(t.dim).child(tilde(r.path))));
    };
    return v_flex()
      .id("space-picker")
      .track_focus(this.handle)
      .size_full()
      .p(14)
      .gap(8)
      .bg(t.popover)
      .text_size(13)
      .on_key_down((e, cx) => {
        if (e.key === "escape") return this.close();
        if (e.key === "down") this.at = (this.at + 1) % Math.max(1, pickable.length);
        else if (e.key === "up") this.at = (this.at + pickable.length - 1) % Math.max(1, pickable.length);
        else return;
        cx.stop_propagation();
        cx.notify();
      })
      .child(
        h_flex()
          .h(36)
          .flex_none()
          .px(10)
          .gap(8)
          .items_center()
          .rounded(9)
          .border_1()
          .border_color(t.input)
          .bg(t.background)
          .child(Input.new(this.input).flex_1().h_full().text_size(13).text_color(t.foreground)),
      )
      .child(
        v_flex()
          .id("sp-list")
          .flex_1()
          .min_h(0)
          .overflow_y_scrollbar()
          .gap(1)
          .children(rows.map(row)),
      )
      .child(
        h_flex()
          .flex_none()
          .px(10)
          .pt(4)
          .text_size(11)
          .text_color(t.dim)
          .child("↑↓ move · ↵ new space · esc close"),
      );
  }
}
