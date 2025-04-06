local opt = vim.opt

-- ファイル
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- 行番号
opt.number = true
opt.relativenumber = true

-- タブ,インデント
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- 検索
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- visual
opt.showmode = true
opt.showcmd = true

vim.o.shell = "fish"

vim.cmd.colorscheme "catppuccin"
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#5d5d63", bg = "NONE" }) -- fgを暗いグレーに設定
vim.o.fillchars = "vert:┃"
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#7f7f7f", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#7f7f7f", bg = "NONE" })

vim.opt.termguicolors = true


-- Clipboard
--vim.g.clipboard = {
--  name = "tmux",
--  copy = {
--    ["+"] = "tmux load-buffer -", -- システムクリップボード用
--    ["*"] = "tmux load-buffer -", -- ビジュアルモードや通常のyank用
--  },
--  paste = {
--    ["+"] = "tmux save-buffer -", -- システムクリップボード用
--    ["*"] = "tmux save-buffer -", -- ビジュアルモードなどのペースト用
--  },
--  cache_enabled = true, -- キャッシュを有効にすることで応答速度を向上
--}
vim.g.clipboard = {
    name = 'xsel',
    copy = {
        ['+'] = 'xsel --clipboard --input',
        ['*'] = 'xsel --primary --input',
    },
    paste = {
        ['+'] = 'xsel --clipboard --output',
        ['*'] = 'xsel --primary --output',
    },
    cache_enabled = 0,
}

