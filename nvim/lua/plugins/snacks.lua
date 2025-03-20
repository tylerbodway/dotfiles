return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
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
