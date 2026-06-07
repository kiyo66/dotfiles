return {
  {
    "SmiteshP/nvim-navic",
    lazy = false,
    config = function()
      local navic = require("nvim-navic")

      navic.setup({
        icons = {
          Class = "CLASS ",
          Method = "METHOD ",
          Function = "FUNC ",
          Constructor = "INIT ",
          Module = "MODULE ",
          Variable = "VAR ",
          Constant = "CONST ",
          Property = "PROP ",
          Field = "FIELD ",
        },

        highlight = true,
        separator = "  >  ",
        depth_limit = 0,
        depth_limit_indicator = "..",
        safe_output = true,

        lsp = {
          auto_attach = false,
        },
      })

      vim.api.nvim_set_hl(0, "NavicIconsClass", {
        fg = "#E5C07B",
        bold = true,
      })

      vim.api.nvim_set_hl(0, "NavicIconsMethod", {
        fg = "#61AFEF",
        bold = true,
      })

      vim.api.nvim_set_hl(0, "NavicIconsFunction", {
        fg = "#98C379",
        bold = true,
      })

      vim.api.nvim_set_hl(0, "NavicIconsConstructor", {
        fg = "#C678DD",
        bold = true,
      })

      vim.api.nvim_set_hl(0, "NavicText", {
        fg = "#D8DEE9",
      })

      vim.api.nvim_set_hl(0, "NavicSeparator", {
        fg = "#5C6370",
      })
    end,
  },
}
