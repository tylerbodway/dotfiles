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
    styles = {
      -- copied from: https://github.com/lucobellic/nvim-config/blob/main/lua/plugins/snacks/snacks-input.lua
      above_cursor = {
        backdrop = false,
        position = "float",
        border = "rounded",
        title_pos = "left",
        height = 1,
        noautocmd = true,
        relative = "cursor",
        row = -3,
        col = 0,
        wo = {
          cursorline = false,
        },
        bo = {
          filetype = "snacks_input",
          buftype = "prompt",
        },
        keys = {
          n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
          i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
          i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = "i", expr = true },
          i_tab = { "<tab>", { "cmp_select_next", "cmp", "fallback" }, mode = "i", expr = true },
          i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
          i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
          i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
          q = "cancel",
        },
      },
    },
  },
  keys = {
    { "\\", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
  },
}
