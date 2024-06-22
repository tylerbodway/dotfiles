-- Treesitter provides better syntax highlighting, editing, navigation, and more
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      'bash',
      'css',
      'csv',
      'diff',
      'dockerfile',
      'git_config',
      'git_rebase',
      'gitcommit',
      'gitignore',
      'go',
      'html',
      'http',
      'javascript',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'ruby',
      'scss',
      'ssh_config',
      'tsx',
      'typescript',
      'yaml',
    },
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  config = function(_, opts) -- see `:help nvim-treesitter`
    -- Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true
    require('nvim-treesitter.configs').setup(opts)
  end,
}
