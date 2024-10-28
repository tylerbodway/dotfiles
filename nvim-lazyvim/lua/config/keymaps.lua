-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- lazygit
-- https://github.com/LazyVim/LazyVim/blob/c1b76ee235a2cccfdf6370ecfca57bdacd5fe6258/lua/lazyvim/config/keymaps.lua#L132-L148
vim.keymap.del("n", "<leader>gG")
vim.keymap.del("n", "<leader>gL")
vim.keymap.del("n", "<leader>gb")
vim.keymap.del("n", "<leader>gB")
vim.keymap.del("n", "<leader>gc")
vim.keymap.del("n", "<leader>ge")
vim.keymap.del("n", "<leader>gs")
vim.keymap.del("t", "<esc><esc>")

-- floating terminal
-- https://github.com/LazyVim/LazyVim/blob/c1b76ee235a2cccff6370ecfca57bdacd5fe6258/lua/lazyvim/config/keymaps.lua#L160-L165
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
vim.keymap.del("n", "<c-/>")
vim.keymap.del("n", "<c-_>")
