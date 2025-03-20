-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- floating terminal
-- https://github.com/LazyVim/LazyVim/blob/c1b76ee235a2cccff6370ecfca57bdacd5fe6258/lua/lazyvim/config/keymaps.lua#L160-L165
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
vim.keymap.del("n", "<c-/>")
vim.keymap.del("n", "<c-_>")
