-- Library of independent Lua modules improving the overall Neovim experience
vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })

-- Icon provider
local icons = require("mini.icons")
icons.setup({
  extension = {
    lua = { hl = "MiniIconsCyan" },
    ts = { hl = "MiniIconsCyan" },
    tsx = { hl = "MiniIconsCyan" },
    jsx = { hl = "MiniIconsBlue" },
    lock = { glyph = "", hl = "MiniIconsYellow" },
    conf = { glyph = "", hl = "MiniIconsGrey" },
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

-- Minimal and fast tabline showing listed buffers
require("mini.tabline").setup()

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
