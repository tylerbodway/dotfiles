vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

-- Always open :help in vertical split
vim.cmd.cnoreabbrev("help vert help") -- :help to :vert help
vim.cmd.cnoreabbrev("h vert help") -- :h to :vert help
