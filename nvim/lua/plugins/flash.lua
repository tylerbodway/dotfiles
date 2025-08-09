-- Navigate with search labels, enhanced character motions, and Treesitter integration
vim.pack.add({ "https://github.com/folke/flash.nvim" })

local flash = require("flash")

flash.setup({
  modes = {
    search = { enabled = true },
  },
})

vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash (treesitter)" })
vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "x", "o" }, "R", function() flash.treesitter_search() end, { desc = "Remote Flash (treesitter)" })
vim.keymap.set("c", "<C-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "vague",
  callback = function() vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#d8647e", fg = "#252530" }) end,
})
