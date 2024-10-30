local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true}

map('i', 'jj', '<ESC>', opts)
map('i', 'っｊ', '<ESC>', opts)
map('i', '{', '{}<Left>', opts)
map('i', '(', '()<Left>', opts)
map('n', '<C-p>', '<cmd>Telescope find_files', opts)
map('n', '<C-g>', '<cmd>Telescope live_grep', opts)
map('v', '<C-c>', '"+y', opts)

-- terminal
map('n', 'tt', ':terminal', opts)
map('n', 'tx', ':belowright new | terminal', opts)
map('t', '<C-q>', '<C-\\><C-n>:q', opts)
map('n', ':tab', ':tabnew', opts)
map('n', ':term', ':terminal', opts)

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
map("n", "K",  "<cmd>Lspsaga hover_doc<CR>", opts)
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

