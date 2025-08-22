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

require("lspsaga").setup({})

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
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item() else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
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

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local key = "__lsp_attached_" .. client.name
    if vim.b[key] then
      client.stop()
      return
    end
    vim.b[key] = true

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

local lspconfig = require("lspconfig")

local __did_setup = {}
local function setup_once(server, opts)
  if __did_setup[server] then return end
  __did_setup[server] = true
  lspconfig[server].setup(opts)
end

local servers = { "lua_ls", "pylsp" }

require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

for _, server in ipairs(servers) do
  local opts = { capabilities = capabilities }
  if server == "lua_ls" then
    opts.settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    }
  elseif server == "pylsp" then
    opts.settings = {
      pylsp = {
        plugins = {
          ruff = { enabled = false },
          pycodestyle = { enabled = false },
          pyflakes = { enabled = false },
          mccabe = { enabled = false },
        },
      },
    }
  end
  setup_once(server, opts)
end

setup_once("ruff", {
  capabilities = capabilities,
  cmd = { "ruff", "server", "--config", vim.fn.expand("~/.config/ruff/ruff.toml") },
})


vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("RuffTweak", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
})

