# AGENTS.md

This document provides guidance for AI coding agents working in this dotfiles repository.

## Repository Overview

This is a personal macOS dotfiles repository managed with [dotbot](https://github.com/anishathalye/dotbot).
It configures applications, command-line tools, and development environment settings.

## Build/Install Commands

```bash
# Full installation (idempotent - safe to run repeatedly)
./install

# Run with verbose output (default)
./install --verbose

# Run specific dotbot plugins only
./install --only=link          # Only symlink files
./install --only=brewfile      # Only install Homebrew packages
./install --only=npm           # Only install npm packages
./install --only=gem           # Only install Ruby gems
./install --only=shell         # Only run shell commands
```

## Project Structure

```
~/.dotfiles/
├── install              # Main installation script (bash)
├── install.conf.yaml    # Dotbot configuration
├── Brewfile             # Homebrew packages, casks, and fonts
├── Gemfile              # Ruby gems for development tools
├── package.json         # Global npm packages (language servers)
├── dotbot/              # Dotbot submodule
├── dotbot-plugins/      # Custom dotbot plugins (Python)
├── nvim/                # Neovim configuration (Lua)
├── zsh/                 # Zsh shell configuration
├── git/                 # Git configuration
├── ghostty/             # Ghostty terminal config
├── opencode/            # OpenCode AI agent config
├── zellij/              # Zellij terminal multiplexer
└── [other app configs]
```

## Code Style Guidelines

### General Formatting

- **Indentation**: 2 spaces (no tabs)
- **Charset**: UTF-8
- **Line endings**: LF
- **Final newline**: Always include
- **Trailing whitespace**: Trim (except in Markdown)

These rules are defined in `.editorconfig` and apply to all files.

### Lua (Neovim Config)

Format with StyLua using `.stylua.toml`:

```bash
stylua nvim/
```

Style settings:

- Column width: 120 characters
- Indent: 2 spaces
- Quote style: Auto-prefer double quotes
- Call parentheses: Always
- Collapse simple statements: Always

Conventions:

- Use `vim.keymap.set()` for keymaps with descriptive `desc` field
- Use `vim.opt.*` for options, `vim.g.*` for globals
- Organize into `core/` (base config) and `plugins/` (plugin setup)
- Use `vim.pack.add()` for plugin management
- Leader key is Space, local leader is Backslash

### Python (Dotbot Plugins)

- Follow PEP 8 style guidelines
- Use f-strings for string formatting
- Class-based plugins extending `dotbot.Plugin`
- Handle errors gracefully with try/except
- Use `self._log` for logging (info, warning, error, action)

### Shell (Zsh/Bash)

- Use `#!/usr/bin/env bash` shebang for portability
- Use `set -e` for fail-fast behavior
- Quote variables: `"${VAR}"` not `$VAR`
- Use lowercase for local variables, UPPERCASE for exports
- Prefer `$(command)` over backticks

### YAML Configuration

- 2-space indentation
- Use descriptive comments for non-obvious settings
- Group related configurations together

### Git Configuration

- Commit signing enabled (SSH via 1Password)
- Default branch: `main`
- Git aliases defined in `git/config`

## File Organization Patterns

### Neovim Plugin Files

Each plugin file in `nvim/lua/plugins/` follows this pattern:

```lua
-- Brief description of the plugin
vim.pack.add({ "https://github.com/author/plugin.nvim" })

local plugin = require("plugin")

plugin.setup({
  -- configuration
})

-- Keymaps
vim.keymap.set("n", "<leader>xx", function() ... end, { desc = "Description" })
```

### Dotbot Plugin Pattern

Custom dotbot plugins in `dotbot-plugins/`:

```python
import dotbot

class PluginName(dotbot.Plugin):
    _directive = "directive_name"

    def can_handle(self, directive):
        return directive == self._directive

    def handle(self, directive, data):
        # Implementation
        return success
```

## Environment Variables

Key environment variables set in `zsh/zprofile`:

- `EDITOR`/`VISUAL`: nvim
- `DOT`: ~/.dotfiles
- `XDG_CONFIG_HOME`: ~/.config
- `XDG_DATA_HOME`: ~/.local/share
- `XDG_STATE_HOME`: ~/.local/state
- `XDG_CACHE_HOME`: ~/.cache

## Key Tools & Aliases

| Alias  | Command    | Purpose                |
| ------ | ---------- | ---------------------- |
| `nv`   | `nvim`     | Neovim editor          |
| `gg`   | `lazygit`  | Git TUI                |
| `oc`   | `opencode` | AI coding agent        |
| `cat`  | `bat`      | Syntax-highlighted cat |
| `ls`   | `eza`      | Modern ls replacement  |
| `grep` | `rg`       | Ripgrep search         |
| `find` | `fd`       | Fast find alternative  |

## LSP Servers

Configured in `nvim/lua/core/lsp.lua`:

- **Lua**: lua_ls
- **Ruby**: ruby_lsp (with rubocop linting)
- **JavaScript/TypeScript**: vtsls, eslint
- **HTML/ERB**: herb_ls, emmet_language_server
- **JSON**: jsonls
- **YAML**: yamlls

Global npm packages provide additional servers (see `package.json`).

## Important Notes for Agents

1. **Symlinks**: Files are symlinked from this repo to their destinations.
   Edit source files here, not the symlinked destinations.

2. **Dotbot submodule**: The `dotbot/` directory is a git submodule.
   Don't modify files within it.

3. **Testing changes**: After editing, run `./install` to apply changes.
   Use the `--only` flag if editing a singular section of `install.conf.yaml`.

4. **Brewfile format**: Each entry has the package, then a comment with description and URL.
   Use the URL and description provided by `brew info <package-name>`

5. **No tests**: This is a configuration repo without a test suite.

6. **Secrets**: Never commit sensitive data.
   Use 1Password secret management strategies if necessary.

7. **Platform**: macOS-specific (Apple Silicon). Some configs assume Homebrew at `/opt/homebrew`.
