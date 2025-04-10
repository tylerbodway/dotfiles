-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Default is \ which I use for the file explorer
vim.g.maplocalleader = ","

vim.opt.swapfile = false

-- http://www.lazyvim.org/extras/lang/ruby#options
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "syntax_tree"

-- https://github.com/kristijanhusak/vim-dadbod-ui?tab=readme-ov-file#via-gdbs-global-variable
vim.g.dbs = {
  groups_development = "mysql://root@pco.test:3306/groups_development",
  account_center_development = "mysql://root@pco.test:3306/account_center_development",
  chat_development = "mysql://root@pco.test:3306/chat_development",
}
