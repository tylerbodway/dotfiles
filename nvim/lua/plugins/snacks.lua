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
    },
    scratch = {
      ft = "markdown",
    },
  },
  keys = {
    { "\\", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
  },
}
