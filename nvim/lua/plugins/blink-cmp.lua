-- Performant, batteries-included completion plugin
vim.pack.add({ "https://github.com/Saghen/blink.cmp" })

-- Set of preconfigured snippets for different languages
-- Auto-included by blink.cmp if available
vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" })

require("blink.cmp").setup({
  fuzzy = { implementation = "lua" },
  keymap = { preset = "super-tab" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "copilot" },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true,
      },
    },
  },
})
