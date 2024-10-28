return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>e", false },
    { "<leader>fe", false },
    { "<leader>E", false },
    { "<leader>fE", false },
    { "\\", "<cmd>Neotree reveal<cr>", desc = "Explorer NeoTree" },
  },
  opts = {
    close_if_last_window = true,
    enable_diagnostics = false,
    filesystem = {
      window = {
        width = 30,
        mappings = {
          ["\\"] = "close_window",
        },
      },
    },
  },
}
