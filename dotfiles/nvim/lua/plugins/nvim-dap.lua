return {
    'mfussenegger/nvim-dap',
    dependencies = {
        "rcarriga/nvim-dap-ui",         -- UI拡張
        "nvim-telescope/telescope-dap.nvim", -- Telescopeと連携
        "theHamsta/nvim-dap-virtual-text",   -- 仮想テキスト表示
        "nvim-neotest/nvim-nio",
    },
    config = function ()

        local dap = require("dap")

        dap.adapters.python = {
            type = 'executable',
            command = 'python3',
            args = { '-m', 'debugpy.adapter' },
        }

        dap.configurations.python = {
            {
                type = 'python',
                request = 'launch',
                name = 'Launch file',
                program = "${file}",
                args = function()
                    local input = vim.fn.input("Enter arguments: ")
                    return vim.split(input, " ")
                end,
                pythonPath = function()
                    return '/usr/bin/python3'
                end,
            },
        }

        local dapui =  require("dapui")
        dapui.setup()
        require('dapui').setup({
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.40 },
                        { id = "stacks", size = 0.30 },
                        { id = "breakpoints", size = 0.10 },
                        { id = "repl", size = 0.20 },
                    },
                    position = "right",
                    size = 50
                },
                {
                    elements = {
                        { id = "watches", size = 0.5 },
                        { id = "console", size = 0.5 },
                    },
                    position = "bottom",
                    size = 20
                }
            },
            floating = {
                border = "rounded" -- フローティングウィンドウのボーダー
            },
        })
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end
}
