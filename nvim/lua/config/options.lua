-- Neovim Options
-- See `:h option-list` and/or `:h <option>` to learn more

-- General
vim.g.mapleader = ' ' -- set <space> as the leader key
vim.g.maplocalleader = ' ' -- set <space> for local leader key
vim.opt.undofile = true -- save undo history
vim.opt.swapfile = false -- turn off swapfile
vim.opt.updatetime = 250 -- decrease update time
vim.opt.timeoutlen = 600 -- determines when which-key appears
vim.opt.mouse = 'a' -- enable mouse mode
vim.opt.clipboard = 'unnamedplus' -- sync clipboard between OS and Neovim

-- Splits
vim.opt.splitright = true -- how vertical splits should open
vim.opt.splitbelow = true -- how horizontal splits should open

-- Search
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- unless you switch case in search term
vim.opt.hlsearch = true -- set highlight on search

-- Visual
vim.g.have_nerd_font = true -- nerd font is installed and selected in the terminal
vim.opt.termguicolors = true -- enable 24-bit RGB color
vim.opt.number = true -- make line numbers default
vim.opt.relativenumber = true -- add relative line numbers to help with jumping
vim.opt.signcolumn = 'yes' -- keep signcolumn on by default
vim.opt.cursorline = true -- show which line the cursor is on
vim.opt.inccommand = 'split' -- preview substitutions as you type
vim.opt.scrolloff = 10 -- minimum # of lines to keep above/below the cursor
vim.opt.list = true -- how to display whitespaces in editor
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.showmode = false -- mode is already in statusline
vim.opt.statuscolumn = '%=%s %l %2(%r%) ' -- git sign, absolute line #, relative line #

-- Indentation
vim.opt.breakindent = true -- enable break indent
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.tabstop = 2 -- 2 spaces for tabs
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.autoindent = true -- copy indent when newlining
