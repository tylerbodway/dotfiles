-- A pretty diagnostics, references, quickfix and location list
vim.pack.add({ "https://github.com/folke/trouble.nvim" })

require("trouble").setup({
  focus = true,
  preview = { type = "split", relative = "win", position = "right", size = 0.4 },
  auto_close = true,
})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Diagnostics (buffer)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (global)" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Diagnostics loclist" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Diagnostics qflist" })

vim.keymap.set(
  "n",
  "<leader>cs",
  "<cmd>Trouble symbols toggle win.style=split win.position=right<CR>",
  { desc = "Symbols" }
)
vim.keymap.set(
  "n",
  "<leader>cr",
  "<cmd>Trouble lsp toggle win.style=split win.position=right<CR>",
  { desc = "LSP refs / defs / etc." }
)
