-- Todo Comments is a plugin to highlight, list, and navigate todo comments
-- https://github.com/folke/todo-comments.nvim

return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local todo_comments = require 'todo-comments'

    local keymap = vim.keymap

    keymap.set('n', ']t', function()
      todo_comments.jump_next()
    end, { desc = 'Next [T]odo comment' })

    keymap.set('n', '[t', function()
      todo_comments.jump_prev()
    end, { desc = 'Previous [T]odo comment' })

    todo_comments.setup()
  end,
}
