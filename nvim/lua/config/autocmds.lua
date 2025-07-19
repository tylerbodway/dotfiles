-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- https://github.com/nvim-treesitter/nvim-treesitter/issues/3363#issuecomment-1538607633
vim.cmd("autocmd FileType ruby setlocal indentkeys-=.")

-- set zprofile filetype to zsh for highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "zprofile",
  callback = function()
    vim.bo.filetype = "zsh"
  end,
})
