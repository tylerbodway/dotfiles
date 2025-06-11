return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { -- Paste clipboard image to chat buffer via :PasteImage
        "HakonHarnes/img-clip.nvim",
        opts = {
          filetypes = {
            codecompanion = {
              prompt_for_file_name = false,
              template = "[Image]($FILE_PATH)",
              use_absolute_path = true,
            },
          },
        },
      },
      { -- Completion for variables, slash commands, and tools
        "saghen/blink.cmp",
        opts = {
          sources = {
            per_filetype = {
              codecompanion = { "codecompanion" },
            },
          },
        },
      },
    },
    opts = {
      strategies = {
        chat = {
          auto_scroll = false,
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4",
          },
          roles = {
            llm = function(adapter)
              return "  AI (" .. adapter.formatted_name .. ": " .. adapter.model.name .. ")"
            end,

            user = "  Me",
          },
        },
        inline = {
          adapter = {
            name = "copilot",
            model = "gpt-4.1",
          },
          keymaps = {
            accept_change = {
              modes = { n = "<leader>ay" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "<leader>an" },
              description = "Reject the suggested change",
            },
          },
        },
      },
      display = {
        chat = {
          intro_message = " ? for options",
          show_header_separator = true,
          window = { width = 0.35 },
        },
        diff = {
          provider = "mini_diff",
        },
      },
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = " Toggle Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          local mode = vim.fn.mode()
          vim.ui.input({
            prompt = "  AI",
            win = {
              style = "above_cursor",
            },
          }, function(input)
            if input and input ~= "" then
              if mode:match("[vV\22]") then
                vim.cmd("'<,'>CodeCompanion " .. input)
              else
                vim.cmd("CodeCompanion " .. input)
              end
            end
          end)
        end,
        desc = " Inline Assistant",
        mode = { "n", "v" },
      },
    },
  },
}
