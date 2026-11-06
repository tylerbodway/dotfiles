---
name: herdr-customization
description: Customize the herdr-app GUI — layouts, mods (panels), keybindings, themes, settings. Use whenever the user wants to add, customize, tweak, clone, fix, or debug herdr-app customization files.
---

# Herdr app customization with dotfiles tracking

Herdr's whole interface is files under `~/.config/herdr-app`; edits apply
live within a second. The app's own docs are the single source of truth for
what can change and how. This skill's job is only the ordering of work and
the dotfiles-tracking policy they live nowhere else.

## 1. Read the version-matched app docs

Read `~/.config/herdr-app/AGENTS.md` in full before touching any file.
Herdr rewrites it on every start to match the running version — its
commands, file formats and API win over anything else remembered or
documented elsewhere. Done when you can name the exact file(s) or command
your change needs.

## 2. Own-only rule

Shipped mods and layouts (main, terminals, win98, and the default mods) are
Herdr's: read them as examples, edit clones. Use `layout.clone` /
`mod.clone` or the palette's Duplicate; new files with your own names are
also yours from birth. Editing a shipped file directly still works, but
Herdr's start-up moves it aside into a `<name>-edited` clone and restores
the shipped default — treat that rescue as the signal to fold the clone
into step 3.

`~/.config/herdr-app/settings.json` is already a symlink into
`~/.dotfiles`; edit either side. The app's writer follows symlinks, so GUI
saves land in the repo as plain git diffs.

## 3. Track author-owned files in the dotfiles

Layouts, mods, themes and `programs.json` you author join
`~/.dotfiles/herdr-app` mirroring the app path, e.g. the clone
`~/.config/herdr-app/layouts/agents-board.json` maps to
`~/.dotfiles/herdr-app/layouts/agents-board.json`:

1. Copy the file(s) into `~/.dotfiles/herdr-app/` at the mirrored
   relative path. The repo copy is the canonical one from here on.
2. Add an explicit entry to the `link:` section of
   `~/.dotfiles/install.conf.yaml`:
   `~/.config/herdr-app/<path>: herdr-app/<path>`
   Explicit links, never globs — shipped file names shift between app
   versions; yours don't.
3. Run `./install --only=link` in `~/.dotfiles` and verify
   `ls -la ~/.config/herdr-app/<path>` shows a symlink. Working file is
   identical on both sides.
4. Apply it in the app per its own docs (mods hot-reload; a layout takes
   `layout.switch`).

Never track: shipped files (`AGENTS.md`, `*.d.ts`, `frame/`, `icons/`,
shipped mods and layouts), and runtime state (`view.json`, `window.json`,
`shared.json`, `seen.json`, `installed.json`, `data/`, `update-notes*`,
`herdr-app.sock`). On a fresh machine the app rebuilds every one of those
itself before you get involved.

`keys.json` gets tracking only when deliberately customized: Herdr merges
new default shortcuts into an untouched keys file on every app upgrade,
and a first edit freezes that behavior for good. Until there's a
customization you care about, leave it out.

## 4. Verify with the user, then commit

Present the finished customization to the user — what changed, where the
files live in the repo, and how it looks/behaves in the app — and wait for
them to confirm it is complete and working as they want. Do not commit
before that confirmation.

Once the user has verified, commit the dotfiles change with the
git-commits skill. Done when `git status` is clean (or shows only pending
user work), the new symlink is in place, and re-running
`./install --only=link` is idempotent.
