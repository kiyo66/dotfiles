vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    command = "startinsert | setlocal norelativenumber | setlocal nonumber",
})

-- install ruff
-- local function is_module_installed(module)
--     local handle = io.popen("python3 -m pip show " .. module .. " 2>/dev/null")
--     if handle == nil then
--         return false
--     end
--     local result = handle:read("*a")
--     handle:close()
--     return result and result ~= ""
-- end
-- 
-- local function install_pylsp_ruff()
--     if not is_module_installed("python-lsp-ruff") then
--         print("Installing python-lsp-ruff...")
--         vim.cmd("PylspInstall python-lsp-ruff")
--     else
--         print("python-lsp-ruff is already installed.")
--     end
-- end

-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = install_pylsp_ruff,
--     once = true,
-- })

-- python formatting
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.py",
  callback = function()
  end
})

-- javascript formatting
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.js", "*.html", "*.css"},
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
  end
})

-- return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
      if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
        vim.cmd("normal! g`\"")
      end
    end
})

local HighlightYank = vim.api.nvim_create_augroup('HighlightYank', {})
vim.api.nvim_create_autocmd('TextYankPost', {
    group = HighlightYank,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

local CleanOnSave = vim.api.nvim_create_augroup('CleanOnSave', {})
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  group = CleanOnSave,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

