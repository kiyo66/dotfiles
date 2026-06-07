if vim.g.__nova_lsp_inited then return end
vim.g.__nova_lsp_inited = true

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "pylsp", "ruff" },
    automatic_installation = true,
})

require("lspsaga").setup({
    lightbulb = { enable = false, sign = false, virtual_text = false, enable_in_insert = false },
})

local cmp = require("cmp")
cmp.setup({
    completion = { completeopt = "menu,menuone,noselect" },
    snippet = {
        expand = function(args)
            local ok, luasnip = pcall(require, "luasnip")
            if ok then luasnip.lsp_expand(args.body) end
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<CR>"]      = cmp.mapping.confirm({ select = false }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item() else fallback() end
        end, { "i", "s" }),
        ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item() else fallback() end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp", priority = 1000 },
    },
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
            vim_item.menu = ({ nvim_lsp = "[LSP]" })[entry.source.name] or ""
            return vim_item
        end,
    },
    experimental = { ghost_text = true },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }

vim.diagnostic.config({
    update_in_insert = false,
    virtual_text = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local key = "__lsp_attached_" .. client.name
        if vim.b[key] then
            client.stop()
            return
        end
        vim.b[key] = true

        if client.name == "pylsp" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end

        local set = vim.keymap.set
        local opts = { noremap = true, silent = true, buffer = args.buf }
        set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
        set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
        set("n", "<C-m>", "<cmd>Lspsaga signature_help<CR>", opts)
        set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        set("n", "rn", "<cmd>Lspsaga rename<CR>", opts)
        set("n", "ma", "<cmd>Lspsaga code_action<CR>", opts)
        set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
        set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    end,
})

vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.lsp.config("pylsp", {
    settings = {
        pylsp = {
            plugins = {
                ruff        = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes    = { enabled = false },
                mccabe      = { enabled = false },
            },
        },
    },
})

vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    init_options = {
        settings = {
            organizeImports = true,
        },
    },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("pylsp")
vim.lsp.enable("ruff")
