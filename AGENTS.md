# AGENTS.md

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

## Brewfile entries

Each line: package, then a comment with a description and URL from `brew info <package>`.

## Important notes

- **Always edit files under `~/.dotfiles`**, never under `~/.config`. The config dirs are symlinks created by dotbot.
- **Apply changes** by running `./install` (or `./install --only=<plugin>`)
- **macOS Silicon only.** Homebrew lives at `/opt/homebrew`
- Leave the `dotbot/` directory alone. It is a git submodule.
