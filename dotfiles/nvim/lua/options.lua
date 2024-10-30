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

