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

opt.clipboard = "unnamedplus"

local function has(bin) return vim.fn.executable(bin) == 1 end
local function paste() return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") } end

local env = vim.env
local is_ssh = (env.SSH_TTY and #env.SSH_TTY > 0) or (env.SSH_CONNECTION and #env.SSH_CONNECTION > 0)
local force_osc52 = (env.NVIM_CLIPBOARD_FORCE_OSC52 == "1") or is_ssh

local osc_ok, osc52_mod = pcall(require, "vim.ui.clipboard.osc52")

local function osc52_provider()
    if not osc_ok then
        if has("wl-copy") then
            return {
                name = "wl-clipboard",
                copy = {
                    ["+"] = { "wl-copy", "--foreground", "--type", "text/plain" },
                    ["*"] = { "wl-copy", "--foreground", "--primary", "--type", "text/plain" },
                },
                paste = {
                    ["+"] = { "wl-paste", "--no-newline" },
                    ["*"] = { "wl-paste", "--primary", "--no-newline" },
                },
            }
        elseif has("xclip") then
            return {
                name = "xclip",
                copy = {
                    ["+"] = { "xclip", "-selection", "clipboard" },
                    ["*"] = { "xclip", "-selection", "primary" },
                },
                paste = {
                    ["+"] = { "xclip", "-selection", "clipboard", "-o" },
                    ["*"] = { "xclip", "-selection", "primary", "-o" },
                },
            }
        elseif has("xsel") then
            return {
                name = "xsel",
                copy = {
                    ["+"] = { "xsel", "--clipboard", "--input" },
                    ["*"] = { "xsel", "--primary", "--input" },
                },
                paste = {
                    ["+"] = { "xsel", "--clipboard", "--output" },
                    ["*"] = { "xsel", "--primary", "--output" },
                },
            }
        end
    end
    return {
        name = "OSC 52",
        copy = {
            ["+"] = osc52_mod.copy("+"),
            ["*"] = osc52_mod.copy("*"),
        },
        paste = { ["+"] = paste, ["*"] = paste },
    }
end

if force_osc52 then
    vim.g.clipboard = osc52_provider()
elseif has("wl-copy") then
    vim.g.clipboard = {
        name = "wl-clipboard",
        copy = {
            ["+"] = { "wl-copy", "--foreground", "--type", "text/plain" },
            ["*"] = { "wl-copy", "--foreground", "--primary", "--type", "text/plain" },
        },
        paste = {
            ["+"] = { "wl-paste", "--no-newline" },
            ["*"] = { "wl-paste", "--primary", "--no-newline" },
        },
    }
elseif has("xclip") then
    vim.g.clipboard = {
        name = "xclip",
        copy = {
            ["+"] = { "xclip", "-selection", "clipboard" },
            ["*"] = { "xclip", "-selection", "primary" },
        },
        paste = {
            ["+"] = { "xclip", "-selection", "clipboard", "-o" },
            ["*"] = { "xclip", "-selection", "primary", "-o" },
        },
    }
elseif has("xsel") then
    vim.g.clipboard = {
        name = "xsel",
        copy = {
            ["+"] = { "xsel", "--clipboard", "--input" },
            ["*"] = { "xsel", "--primary", "--input" },
        },
        paste = {
            ["+"] = { "xsel", "--clipboard", "--output" },
            ["*"] = { "xsel", "--primary", "--output" },
        },
    }
else
    vim.g.clipboard = osc52_provider()
end
