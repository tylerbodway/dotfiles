-- A collection of small quality of life plugins
vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
  bigfile = { enabled = true },
  bufdelete = { enabled = true },
  dashboard = {
    enabled = true,
    width = 50,
    preset = {
      keys = {
        { icon = " ", key = "e", desc = "Explorer", action = ":lua Snacks.explorer()" },
        { icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
        { icon = " ", key = "/", desc = "Find text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      {
        padding = 0,
        align = "center",
        -- stylua: ignore start
        text = {
          { "█▀▀▄ █▀▀ █▀▀█", hl = "Comment" }, { " █  █ █ █▀▀▄▀▀▄\n" },
          { "█░░█ █▀▀ █░░█", hl = "Comment" }, { " █░░█ █ █░░█░░█\n" },
          { "▀  ▀ ▀▀▀ ▀▀▀▀", hl = "Comment" }, { "  ▀▀  ▀ ▀  ▀  ▀" },
        },
        -- stylua: ignore end
      },
      {
        padding = 3,
        align = "center",
        text = (function()
          local version = "v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
          return {
            {
              string.rep(" ", 29 - string.len(version)) .. version,
              hl = "NonText",
            },
          }
        end)(),
      },
      { section = "keys", padding = 2, gap = 1 },
      {
        section = "recent_files",
        padding = 1,
        limit = 6,
        cwd = true,
        filter = function(pathname) return not pathname:match(".git") end,
      },
    },
  },
  explorer = { enabled = true },
  picker = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  lazygit = { enabled = true, configure = false },
  notifier = { enabled = true },
  scope = {
    enabled = true,
    keys = {
      textobject = {
        ii = { desc = "inner indent" },
        ai = { desc = "indent" },
      },
    },
  },
  scratch = { enabled = true, ft = "snacks_scratch" },
  scroll = { enabled = true },
  select = { enabled = true },
  statuscolumn = { enabled = true },
  toggle = { enabled = true },
  zen = { enabled = true },
  styles = {
    lazygit = {
      width = 0,
      height = 0.99,
      border = "none",
    },
    scratch = {
      width = 60,
      height = 30,
      row = 0,
      col = vim.o.columns - 60,
      wo = { signcolumn = "no" },
    },
    above_cursor = {
      relative = "cursor",
      position = "float",
      height = 1,
      row = -3,
      col = 0,
      backdrop = false,
      title_pos = "left",
      border = "rounded",
    },
  },
})

-- Bufdelete
vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", function() Snacks.bufdelete.all() end, { desc = "Delete all buffers" })
vim.keymap.set("n", "<leader>bO", function() Snacks.bufdelete.other() end, { desc = "Delete other buffers" })

-- Explorer
vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "Toggle explorer" })
vim.keymap.set("n", "<leader>fe", function() Snacks.explorer.reveal() end, { desc = "Show in explorer" })
vim.keymap.set("n", "<leader>fn", function() Snacks.rename.rename_file() end, { desc = "Rename file" })

-- Git
vim.keymap.set({ "n", "v" }, "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Blame line" })

-- Lazygit
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log_file() end, { desc = "Lazygit log (current file)" })
vim.keymap.set("n", "<leader>gL", function() Snacks.lazygit.log() end, { desc = "Lazygit log" })

-- Pickers
local picker = Snacks.picker
vim.keymap.set("n", "<leader><Space>", function() picker.smart() end, { desc = "Smart find" })
vim.keymap.set("n", "<leader>/", function() picker.grep() end, { desc = "Find text" })
vim.keymap.set("n", "<leader>,", function() picker.buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>:", function() picker.command_history() end, { desc = "Command history" })
vim.keymap.set("n", "<leader>n", function() picker.notifications() end, { desc = "Notification history" })
-- find
vim.keymap.set("n", "<leader>fb", function() picker.buffers() end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>ff", function() picker.files() end, { desc = "Find files" })
vim.keymap.set(
  "n",
  "<leader>fr",
  function() picker.recent({ filter = { cwd = true } }) end,
  { desc = "Find recent files" }
)
vim.keymap.set(
  "n",
  "<leader>fs",
  function() picker.files({ cwd = vim.fn.stdpath("data") .. "/site/pack/core/opt/friendly-snippets/snippets" }) end,
  { desc = "Find snippets" }
)
-- search
vim.keymap.set("n", "<leader>sb", function() picker.lines() end, { desc = "Search buffer lines" })
vim.keymap.set("n", "<leader>sB", function() picker.grep_buffers() end, { desc = "Find text in buffers" })
vim.keymap.set("n", "<leader>sg", function() picker.grep() end, { desc = "Find text" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function() picker.grep_word() end, { desc = "Search word" })
vim.keymap.set("n", "<leader>sp", function() picker.search_history() end, { desc = "Previous searches" })
vim.keymap.set("n", "<leader>sa", function() picker.autocmds() end, { desc = "Autocommands" })
vim.keymap.set("n", "<leader>sc", function() picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", function() picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", function() picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sD", function() picker.diagnostics_buffer() end, { desc = "Buffer diagnostics" })
vim.keymap.set("n", "<leader>sh", function() picker.help() end, { desc = "Help pages" })
vim.keymap.set("n", "<leader>sH", function() picker.highlights() end, { desc = "Highlights" })
vim.keymap.set("n", "<leader>si", function() picker.icons() end, { desc = "Icons" })
vim.keymap.set("n", "<leader>sj", function() picker.jumps() end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", function() picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl", function() picker.loclist() end, { desc = "Location list" })
vim.keymap.set("n", "<leader>sm", function() picker.marks() end, { desc = "Marks" })
vim.keymap.set("n", "<leader>sq", function() picker.qflist() end, { desc = "Quickfix list" })
-- lsp
vim.keymap.set("n", "gd", function() picker.lsp_definitions() end, { desc = "Go to definition" })
vim.keymap.set("n", "gD", function() picker.lsp_declarations() end, { desc = "Go to declaration" })
vim.keymap.set("n", "gr", function() picker.lsp_references() end, { desc = "Go to reference" })
vim.keymap.set("n", "gI", function() picker.lsp_implementations() end, { desc = "Go to implementation" })
vim.keymap.set("n", "gy", function() picker.lsp_type_definitions() end, { desc = "Go to type definition" })
vim.keymap.set("n", "<leader>ss", function() picker.lsp_symbols() end, { desc = "Search symbols" })
vim.keymap.set("n", "<leader>sS", function() picker.lsp_workspace_symbols() end, { desc = "Search workspace symbols" })

-- Scratch
vim.keymap.set("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle scratch buffer" })

-- Toggle
Snacks.toggle.diagnostics({ name = "diagnostics" }):map("<leader>ud")
Snacks.toggle.inlay_hints({ name = "inlay hints" }):map("<leader>uh")
Snacks.toggle.line_number({ name = "line numbers" }):map("<leader>ul")
Snacks.toggle.option("spell", { name = "spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "line wrap" }):map("<leader>uw")
Snacks.toggle.zen({ name = "zen mode" }):map("<leader>uz")

Snacks.toggle({
  name = "auto format (buffer)",
  get = function()
    local baf = vim.b.autoformat
    if baf == nil then return vim.g.autoformat end
    return baf
  end,
  set = function()
    local baf = vim.b.autoformat
    if baf == nil then baf = vim.g.autoformat end
    vim.b.autoformat = not baf
  end,
}):map("<leader>uf")

Snacks.toggle({
  name = "auto format (global)",
  get = function() return vim.g.autoformat end,
  set = function() vim.g.autoformat = not vim.g.autoformat end,
}):map("<leader>uF")
