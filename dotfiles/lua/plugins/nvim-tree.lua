return {
    "nvim-tree/nvim-tree.lua",
    config = function()
        require("nvim-tree").setup({
            filters = {
                dotfiles = false,
            },
        })
    end,
    keys = {
        {mode = "n", "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle a NvimTree"},
    },
}
