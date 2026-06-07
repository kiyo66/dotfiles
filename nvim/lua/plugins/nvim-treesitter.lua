return {
  {
    "nvim-treesitter/nvim-treesitter",
<<<<<<< HEAD
    branch = "master",
=======
<<<<<<< HEAD
    branch = "main",
    lazy = false,
>>>>>>> 5f116ac (init)
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "lua", "vim", "vimdoc" },
        highlight = { enable = true },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
<<<<<<< HEAD
=======
    branch = "main",
=======
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "lua", "vim", "vimdoc" },
        highlight = { enable = true },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
>>>>>>> 47ebeb2 (init)
>>>>>>> 5f116ac (init)
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
