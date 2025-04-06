return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "jay-babu/mason-null-ls.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.code_actions.gomodifytags,
      },
    })
    require("mason-null-ls").setup({})
  end,
}

