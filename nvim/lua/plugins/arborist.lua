-- Treesitter parser management (highlighting and indentation are built into Neovim 0.12+)
vim.pack.add({ "https://github.com/arborist-ts/arborist.nvim" })

require("arborist").setup({
  update_cadence = "weekly",
  install_popular = false,
})
