return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        no_italic = true,
        term_colors = true,
        transparent_background = false,
        styles = {
            comments = {},
            conditionals = {},
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
        },
        color_overrides = {
            mocha = {
                base = "#1b1b1b",
                mantle = "#1b1b1b",
                crust = "#1b1b1b",
            },
            latte = {
                base = "#ff0000",
                mantle = "#242424",
                crust = "#474747",
            },
            integrations = {
                telescope = {
                enabled = true,
                -- style = "nvchad",
            },
            dropbar = {
                enabled = false,
                color_mode = false,
            },
        },
    }
}}

