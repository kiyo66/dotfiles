local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('i', 'jj', '<ESC>', opts)
map('i', 'っｊ', '<ESC>', opts)
map('n', '<C-p>', '<cmd>Telescope find_files<CR>', opts)
map('n', '<C-g>', '<cmd>Telescope live_grep<CR>', opts)
map('v', '<C-c>', '"+y', opts)

-- terminal
map('n', 'tt', ':terminal', opts)
map('n', 'tx', ':belowright new | terminal', opts)
map('t', '<C-q>', '<C-\\><C-n>', opts)
map('n', ':ta', ':tabnew', opts)

-- use keymap in file-header-view(bufferline-plugin)
-- bufferline close setting
map('n', '<leader>wl', '<cmd>BufferLineCloseRight<CR>', opts)
map('n', '<leader>wh', '<cmd>BufferLineCloseLeft<CR>', opts)
map('n', '<leader>wall', '<cmd>BufferLineCloseOthers<CR>', opts)
map('n', '<leader>we', '<cmd>BufferLinePickClose<CR>', opts)

-- (reference)https://github.com/kazhala/dotfiles/blob/master/.config/nvim/lua/kaz/plugins/bufferline.lua
map('n', 'gb', '<cmd>BufferLinePick<CR>', opts)
map('n', '<leader>ts', '<cmd>BufferLinePickClose<CR>', opts)
map('n', '<S-l>', '<cmd>BufferLineCycleNext<CR>', opts)
map('n', '<S-h>', '<cmd>BufferLineCyclePrev<CR>', opts)
map('n', ']b', '<cmd>BufferLineMoveNext<CR>', opts)
map('n', '[b', '<cmd>BufferLineMovePrev<CR>', opts)
map('n', 'gs', '<cmd>BufferLineSortByDirectory<CR>', opts)

-- lspsaga
map("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
map('n', 'gr', '<cmd>Lspsaga lsp_finder<CR>', opts)
map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
map("n", "ga", "<cmd>Lspsaga code_action<CR>", opts)
map("n", "gn", "<cmd>Lspsaga rename<CR>", opts)
map("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
map("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
map("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)

-- shift
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "gl", "gt", opts)
map("n", "gh", "gT", opts)

-- debug dap
map('n', '<F5>', ':DapContinue<CR>', { silent = true })
map('n', '<F10>', ':DapStepOver<CR>', { silent = true })
map('n', '<F11>', ':DapStepInto<CR>', { silent = true })
map('n', '<F12>', ':DapStepOut<CR>', { silent = true })
map('n', '<leader>b', ':DapToggleBreakpoint<CR>', { silent = true })
map('n', '<leader>B', ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))<CR>',
    { silent = true })
map('n', '<leader>lp', ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
    { silent = true })
map('n', '<leader>dr', ':lua require("dap").repl.open()<CR>', { silent = true })
map('n', '<leader>dl', ':lua require("dap").run_last()<CR>', { silent = true })
-- debug dap ui
map('n', '<leader>d', ':lua require("dapui").toggle()<CR>', {})

--batch conversion
function ReplaceWord()
    local word = vim.fn.input("Replace: ")
    local replacement = vim.fn.input("With: ")
    vim.cmd("%s/" .. word .. '/' .. replacement .. "/g")
end

vim.api.nvim_create_user_command("Replace", ReplaceWord, {})

function ReplaceWordWithConfirm()
    local word = vim.fn.input("Replace: ")
    local replacement = vim.fn.input("With: ")
    vim.cmd("%s/" .. word .. '/' .. replacement .. "/gc")
end

vim.api.nvim_create_user_command("CReplace", ReplaceWordWithConfirm, {})
