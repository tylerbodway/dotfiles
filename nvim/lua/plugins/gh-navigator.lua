return {
  "wassimk/gh-navigator.nvim",
  version = "*",
  config = true,
  cond = function()
    -- Check if the current directory has a git repository
    ---@diagnostic disable-next-line: undefined-field
    return vim.loop.fs_stat(vim.loop.cwd() .. "/.git") ~= nil
  end,
}
