return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazygit" },
    { "<leader>gl", "<cmd>LazyGitFilter<cr>", desc = "Lazygit Log" },
    { "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "Lazygit Log (Current File)" },
  },
  init = function()
    vim.g.lazygit_floating_window_scaling_factor = 0.95
  end,
}
