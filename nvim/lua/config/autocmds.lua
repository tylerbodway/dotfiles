-- Neovim Autocommands
-- see `:help lua-guide-autocommands`

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('UserYank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
