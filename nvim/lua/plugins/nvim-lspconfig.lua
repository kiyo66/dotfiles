return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "SmiteshP/nvim-navic",
    },
    config = function()
      local navic = require("nvim-navic")

      vim.lsp.config("pylsp", {
        settings = {
          pylsp = {
            plugins = {
              jedi_symbols = {
                enabled = true,
                all_scopes = true,
                include_import_symbols = false,
              },
            },
          },
        },
      })

      vim.lsp.enable("pylsp")

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("clangd")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("yamlls")

      local ignored_clients = {
        ruff = true,
        ruff_lsp = true,
        null_ls = true,
        copilot = true,
        copilot_ls = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("navic_attach_all_languages", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if not client then
            return
          end

          if ignored_clients[client.name] then
            return
          end

          if not client.server_capabilities.documentSymbolProvider then
            return
          end

          if navic.is_available(bufnr) then
            return
          end

          navic.attach(client, bufnr)

          for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
            vim.api.nvim_set_option_value(
              "winbar",
              "%{%v:lua.require'nvim-navic'.get_location()%}",
              { scope = "local", win = winid }
            )
          end
        end,
      })
    end,
  },
}
