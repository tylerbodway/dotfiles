-- Configs for the Neovim LSP client
-- https://github.com/neovim/nvim-lspconfig

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    { 'antosha417/nvim-lsp-file-operations', config = true },
    { 'folke/neodev.nvim', opts = {} },
    { 'j-hui/fidget.nvim', opts = {} }, -- useful status updates UI for LSP
  },
  config = function()
    local lspconfig = require 'lspconfig'
    local mason_lspconfig = require 'mason-lspconfig'
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'

    -- Setup Keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspAttach', {}),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        local builtin = require 'telescope.builtin'
        map('gr', builtin.lsp_references, '[G]oto [R]eference')
        map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
        map('gi', builtin.lsp_implementations, '[G]oto [I]mplementation')
        map('gt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')
        map('<leader>#', builtin.lsp_document_symbols, 'Goto Document Symbols')
        map('<leader>##', builtin.lsp_dynamic_workspace_symbols, 'Goto Workspace Symbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame')
        map('<leader>ra', vim.lsp.buf.code_action, '[R]un Code [A]ction')
        map('<leader>rs', '<cmd>LspRestart<CR>', '[R]e[S]tart Server')
        map('K', vim.lsp.buf.hover, 'Hover Documentation') -- see `:help K` for why this key

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Autocommands to highlight references of word under cursor hold
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup('UserLspHighlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('UserLspDetach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'UserLspHighlight', buffer = event2.buf }
            end,
          })
        end

        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    --  Extend Neovim's LSP capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    mason_lspconfig.setup_handlers {
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup {
          capabilities = capabilities,
        }
      end,
      -- custom handlers for server-specific configuration
      ['emmet_ls'] = function()
        lspconfig['emmet_ls'].setup {
          capabilities = capabilities,
          filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'svelte' },
        }
      end,
      ['lua_ls'] = function()
        lspconfig['lua_ls'].setup {
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        }
      end,
    }
  end,
}
