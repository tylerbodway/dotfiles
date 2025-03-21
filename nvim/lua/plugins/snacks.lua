return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
      },
      formatters = {
        file = { truncate = 72 },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
    },
    scratch = {
      ft = "markdown",
    },
  },
  keys = {
    { "\\", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
  },
}
