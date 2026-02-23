return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = "never",
      },
      formatters = {
        ruff_organize_imports = {
          command = "ruff",
          args = {
            "check",
            "--select",
            "I",
            "--fix",
            "--exit-zero",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
          stdin = true,
        },
        ruff_format = {
          command = "ruff",
          args = {
            "format",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
          stdin = true,
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
      },
    })
  end,
}
