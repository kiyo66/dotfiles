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
map("n", "<F5>", "<cmd>DapContinue<CR>", opts)
map("n", "<leader>ds", "<cmd>DapContinue<CR>", opts)
map("n", "<leader>de", "<cmd>lua require('dap').terminate()<CR>", opts)
map("n", "<F10>", "<cmd>DapStepOver<CR>", opts)
map("n", "<leader>dw", "<cmd>DapStepOver<CR>", opts)
map("n", "<F11>", "<cmd>DapStepInto<CR>", opts)
map("n", "<leader>di", "<cmd>DapStepInto<CR>", opts)
map("n", "<F12>", "<cmd>DapStepOut<CR>", opts)
map("n", "<leader>do", "<cmd>DapStepOut<CR>", opts)
map("n", "<leader>b", "<cmd>DapToggleBreakpoint<CR>", opts)
map("n", "<leader>B","<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",opts)
map("n","<leader>lp","<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",opts)
map("n", "<leader>dr", "<cmd>lua require('dap').repl.open()<CR>", opts)
map("n", "<leader>dl", "<cmd>lua require('dap').run_last()<CR>", opts)
map("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>", opts)
map("n", "<leader>dt", "<cmd>lua require('dap-python').test_method()<CR>", opts)
map("n", "<leader>dT", "<cmd>lua require('dap-python').test_class()<CR>", opts)

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
