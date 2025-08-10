-- GitHub Copilot AI completion
vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" })
-- easy integration with blink.cmp
vim.pack.add({ "https://github.com/fang2hou/blink-copilot" })

require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

require("blink-copilot").setup({
  max_completions = 2, -- number of completion menu items
  debounce = 1500, -- longer debounce reduces queries
})

vim.keymap.set("n", "<leader>aga", "<cmd>Copilot auth<CR>", { desc = "Authenticate Copilot" })
vim.keymap.set("n", "<leader>age", "<cmd>Copilot enable<CR>", { desc = "Enable Copilot" })
vim.keymap.set("n", "<leader>agd", "<cmd>Copilot disable<CR>", { desc = "Disable Copilot" })
