local map = vim.keymap.set

-- Buffers / files
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<leader>br", function()
  vim.ui.input({ prompt = "Rename buffer: " }, function(name)
    if name and name ~= "" then vim.cmd("file " .. name) end
  end)
end, { desc = "Rename buffer" })

-- Splits / windows
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-S-h>", "<C-w>H", { desc = "Move window left" })
map("n", "<C-S-j>", "<C-w>J", { desc = "Move window down" })
map("n", "<C-S-k>", "<C-w>K", { desc = "Move window up" })
map("n", "<C-S-l>", "<C-w>L", { desc = "Move window right" })
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })

-- Lines
map("n", "<C-A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<C-A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("i", "<C-A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<C-A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
map("v", "<C-A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<C-A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Indenting
map("v", ">", ">gv", { desc = "Indent right" })
map("v", "<", "<gv", { desc = "Indent left" })

-- Searching
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Diagnostics
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Quitting
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
