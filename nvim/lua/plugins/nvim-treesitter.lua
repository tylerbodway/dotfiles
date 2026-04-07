-- Treesitter parser management (highlighting and indentation are built into Neovim 0.12+)
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("nvim-treesitter").install({
  "bash",
  "css",
  "csv",
  "diff",
  "dockerfile",
  "editorconfig",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "go",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "kdl",
  "lua",
  "markdown",
  "markdown_inline",
  "mermaid",
  "ruby",
  "scss",
  "toml",
  "typescript",
  "yaml",
})

-- Whenever upgrading the plugin, also run :TSUpdate to upgrade all parsers
vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle nvim-treesitter updates",
  group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
  callback = function(event)
    if event.data.kind == "update" then
      vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
      local ok = pcall(vim.cmd, "TSUpdate")
      if ok then
        vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
      else
        vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
      end
    end
  end,
})
