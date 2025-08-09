-- Gutter
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.fillchars = { eob = " " }

-- Indentation
vim.opt.tabstop = 2 -- tab character width
vim.opt.shiftwidth = 2 -- shift width when using >>
vim.opt.expandtab = true -- tab inserts spaces instead
vim.opt.softtabstop = 2 -- spaces inserted by tab
vim.opt.smartindent = true -- indent based on syntax
vim.opt.autoindent = true -- copy previous line indent
vim.opt.showmatch = true -- highlight matching brackets

-- Whitespace
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Cursor
vim.opt.cursorline = true -- highlight current line
vim.opt.scrolloff = 8 -- vertical padding
vim.opt.sidescrolloff = 8 -- horizontal padding

-- Text wrapping
vim.opt.wrap = false -- disabled by default
vim.opt.breakindent = true -- use same indent if enabled

-- Searching
vim.opt.ignorecase = true -- case-insensitive by default
vim.opt.smartcase = true -- case-sensitive if uppercase is used
vim.opt.hlsearch = true -- highlight search results
vim.opt.incsearch = true -- show matches while typing

-- Substitution
vim.opt.inccommand = "nosplit" -- show :%s previews inline

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- File handling
vim.opt.backup = false -- don't use backup files
vim.opt.writebackup = false -- don't write backup files
vim.opt.swapfile = false -- don't track session state
vim.opt.undofile = false -- don't track undo history beyond close
vim.opt.autoread = true -- auto-reload when file changes externally
vim.opt.autochdir = false -- don't auto-cd when moving around tree

-- Sync clipboard with OS
vim.opt.clipboard = "unnamedplus"

-- Mouse support
vim.opt.mouse = "a"

-- Timing
vim.opt.updatetime = 200 -- event triggers after typing
vim.opt.timeoutlen = 200 -- key sequence wait time

-- Remove mode from the command line
vim.opt.showmode = false

-- Confirm buffer save before command fails or discards changes
vim.opt.confirm = true

-- Set default border on all floating windows
vim.opt.winborder = "rounded"

-- Enables 24-bit RGB color in TUI
vim.opt.termguicolors = true
