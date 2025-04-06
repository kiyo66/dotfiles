return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        opts = {
            ensure_installed = {
                'lua',
                'vim',
                'vimdoc',
                'markdown',
                'markdown_inline',
                'python',
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "CursorMoved",
    },
}

