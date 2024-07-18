return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazygit" },
    { "<leader>gl", "<cmd>LazyGitFilter<cr>", desc = "Lazygit Log" },
    { "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "Lazygit Log (Current File)" },
  },
  config = function()
    require("telescope").load_extension("lazygit")
  end,
  init = function()
    vim.g.lazygit_floating_window_scaling_factor = 0.95
  end,
}
