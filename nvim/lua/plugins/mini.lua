-- Library of independent Lua modules improving the overall Neovim experience
vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })

-- Icon provider
local icons = require("mini.icons")
icons.setup({
  default = { directory = { hl = "MiniIconsYellow" } },
  extension = {
    conf = { glyph = "", hl = "MiniIconsGrey" },
    jsx = { hl = "MiniIconsBlue" },
    lock = { glyph = "", hl = "MiniIconsYellow" },
    lua = { hl = "MiniIconsCyan" },
    theme = { glyph = "", hl = "MiniIconsPurple" },
    tmTheme = { glyph = "", hl = "MiniIconsPurple" },
    ts = { hl = "MiniIconsCyan" },
    tsx = { hl = "MiniIconsCyan" },
  },
  file = {
    Brewfile = { glyph = "", hl = "MiniIconsYellow" },
    config = { glyph = "", hl = "MiniIconsGrey" },
    Claude = { glyph = "󰚩", hl = "MiniIconsOrange" },
    devbox = { glyph = "", hl = "MiniIconsGrey" },
    editorconfig = { glyph = "", hl = "MiniIconsCyan" },
    Guardfile = { glyph = "󰶚", hl = "MiniIconsGrey" },
  },
})
icons.mock_nvim_web_devicons()

-- Auto-pair brackets, parentheses, quotes, etc.
require("mini.pairs").setup()

-- Fast and feature-rich surround actions
require("mini.surround").setup({
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
  },
})

-- Highlight patterns with colors
require("mini.hipatterns").setup({
  highlighters = {
    hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
    rgb_color = {
      pattern = "rgb%((%d+),? ?(%d+),? ?(%d+)%)",
      group = function(_, match)
        local r, g, b = match:match("rgb%((%d+),? ?(%d+),? ?(%d+)%)")
        return string.format("#%02x%02x%02x", r, g, b)
      end,
    },
  },
})

-- Work with diff hunks.
require("mini.diff").setup()

-- Minimal and fast tabline showing listed buffers
-- Defer setup until after startup to avoid issues with package installation
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function() require("mini.tabline").setup() end,
})

-- with multiple buffers open, show tabline with bottom padding via winbar
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
  callback = function()
    vim.schedule(function()
      local buf_count = #vim.fn.getbufinfo({ buflisted = 1 })
      if buf_count > 1 then
        vim.opt.showtabline = 2 -- always show
        vim.opt.winbar = " "
      else
        vim.opt.showtabline = 0 -- hide
        vim.opt.winbar = ""
      end
    end)
  end,
})

-- customize tabline colors
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "vague",
  callback = function()
    vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "MiniTablineFill", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "MiniTablineCurrent", { bg = "#252530", fg = "#d7d7d7" })
    vim.api.nvim_set_hl(0, "MiniTablineVisible", { bg = "#252530", fg = "#606079" })
    vim.api.nvim_set_hl(0, "MiniTablineHidden", { bg = "#141415", fg = "#606079" })
  end,
})
