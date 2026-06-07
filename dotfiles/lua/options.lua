local opt = vim.opt

opt.backup = false
opt.writebackup = false
opt.swapfile = false

opt.number = true
opt.relativenumber = true
vim.o.cursorline = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

opt.showmode = true
opt.showcmd = true

vim.o.autoread = true
opt.signcolumn = "yes:2"

vim.o.shell = "fish"

vim.cmd.colorscheme "catppuccin"
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#5d5d63", bg = "NONE" })
vim.o.fillchars = "vert:┃"
vim.api.nvim_set_hl(0, "StatusLine", { fg = "#7f7f7f", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#7f7f7f", bg = "NONE" })

vim.opt.termguicolors = true

-- Clipboard: OSC52 only
local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end

local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")

if not ok then
    vim.notify(
        "vim.ui.clipboard.osc52 is not available. OSC52 clipboard is disabled.",
        vim.log.levels.ERROR
    )
else
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = osc52.copy("+"),
            ["*"] = osc52.copy("*"),
        },
        paste = {
            ["+"] = paste,
            ["*"] = paste,
        },
    }
end
