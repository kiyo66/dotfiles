return {
  {
    "rcarriga/nvim-dap-ui",

    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",

      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },

      {
        "mfussenegger/nvim-dap-python",
      },
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      local LEFT_WIDTH = 48

      vim.fn.sign_define("DapBreakpoint", {
        text = "🔴",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointCondition", {
        text = "🟡",
        texthl = "DapBreakpointCondition",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapLogPoint", {
        text = "📝",
        texthl = "DapLogPoint",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointRejected", {
        text = "🚫",
        texthl = "DapBreakpointRejected",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = "▶",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "DapStopped",
      })

      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff5555" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f1fa8c" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#8be9fd" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#ff5555" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#50fa7b" })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2a2e39" })

      vim.api.nvim_set_hl(0, "DapToolbarPlay", { fg = "#a6e3a1", bold = true })
      vim.api.nvim_set_hl(0, "DapToolbarStep", { fg = "#89b4fa", bold = true })
      vim.api.nvim_set_hl(0, "DapToolbarStop", { fg = "#f38ba8", bold = true })
      vim.api.nvim_set_hl(0, "DapToolbarRestart", { fg = "#a6e3a1", bold = true })
      vim.api.nvim_set_hl(0, "DapToolbarDisconnect", { fg = "#f38ba8", bold = true })

      vim.api.nvim_set_hl(0, "DapToolbarPlayHint", { fg = "#7ba97a", italic = true })
      vim.api.nvim_set_hl(0, "DapToolbarStepHint", { fg = "#6f8fbc", italic = true })
      vim.api.nvim_set_hl(0, "DapToolbarStopHint", { fg = "#b66f82", italic = true })
      vim.api.nvim_set_hl(0, "DapToolbarRestartHint", { fg = "#7ba97a", italic = true })
      vim.api.nvim_set_hl(0, "DapToolbarDisconnectHint", { fg = "#b66f82", italic = true })

      vim.opt.signcolumn = "yes:2"

      local toolbar_buf = nil
      local toolbar_ns = vim.api.nvim_create_namespace("dap_toolbar_hint")

      local toolbar_items = {
        {
          icon = "▶",
          key = "F5/<le>ds",
          icon_hl = "DapToolbarPlay",
          key_hl = "DapToolbarPlayHint",
        },
        {
          icon = "↓",
          key = "F11/<le>di",
          icon_hl = "DapToolbarStep",
          key_hl = "DapToolbarStepHint",
        },
        {
          icon = "↑",
          key = "F12/<le>do",
          icon_hl = "DapToolbarStep",
          key_hl = "DapToolbarStepHint",
        },
        {
          icon = "↷",
          key = "F10/<le>dw",
          icon_hl = "DapToolbarStep",
          key_hl = "DapToolbarStepHint",
        },
        {
          icon = "■",
          key = "<le>de",
          icon_hl = "DapToolbarStop",
          key_hl = "DapToolbarStopHint",
        },
        {
          icon = "↻",
          key = "<le>dl",
          icon_hl = "DapToolbarRestart",
          key_hl = "DapToolbarRestartHint",
        },
        {
          icon = "□",
          key = "",
          icon_hl = "DapToolbarDisconnect",
          key_hl = "DapToolbarDisconnectHint",
        },
      }

      local function center_cell(text, width)
        local text_width = vim.fn.strdisplaywidth(text)
        local total_padding = math.max(width - text_width, 0)
        local left_padding = math.floor(total_padding / 2)
        local right_padding = total_padding - left_padding

        return string.rep(" ", left_padding) .. text .. string.rep(" ", right_padding)
      end

      local function build_toolbar_lines()
        local widths = {}

        for i, item in ipairs(toolbar_items) do
          local icon_width = vim.fn.strdisplaywidth(item.icon)
          local key_width = vim.fn.strdisplaywidth(item.key)
          widths[i] = math.max(icon_width, key_width) + 6
        end

        local icon_line = ""
        local key_line = ""
        local icon_ranges = {}
        local key_ranges = {}

        for i, item in ipairs(toolbar_items) do
          local icon_cell = center_cell(item.icon, widths[i])
          local key_cell = center_cell(item.key, widths[i])

          local icon_start = #icon_line
          icon_line = icon_line .. icon_cell
          local icon_end = #icon_line

          local key_start = #key_line
          key_line = key_line .. key_cell
          local key_end = #key_line

          table.insert(icon_ranges, {
            start_col = icon_start,
            end_col = icon_end,
            hl = item.icon_hl,
          })

          table.insert(key_ranges, {
            start_col = key_start,
            end_col = key_end,
            hl = item.key_hl,
          })
        end

        local max_width = math.max(
          vim.fn.strdisplaywidth(icon_line),
          vim.fn.strdisplaywidth(key_line)
        )

        local padding = math.max(math.floor((vim.o.columns - max_width) / 2), 0)
        local prefix = string.rep(" ", padding)

        for _, range in ipairs(icon_ranges) do
          range.start_col = range.start_col + #prefix
          range.end_col = range.end_col + #prefix
        end

        for _, range in ipairs(key_ranges) do
          range.start_col = range.start_col + #prefix
          range.end_col = range.end_col + #prefix
        end

        return {
          lines = {
            prefix .. icon_line,
            prefix .. key_line,
          },
          ranges = {
            icon_ranges,
            key_ranges,
          },
        }
      end

      local function get_toolbar_buf()
        if toolbar_buf and vim.api.nvim_buf_is_valid(toolbar_buf) then
          return toolbar_buf
        end

        toolbar_buf = vim.api.nvim_create_buf(false, true)

        vim.api.nvim_set_option_value("buftype", "nofile", { buf = toolbar_buf })
        vim.api.nvim_set_option_value("bufhidden", "hide", { buf = toolbar_buf })
        vim.api.nvim_set_option_value("swapfile", false, { buf = toolbar_buf })
        vim.api.nvim_set_option_value("modifiable", false, { buf = toolbar_buf })

        return toolbar_buf
      end

      pcall(dapui.register_element, "toolbar", {
        buffer = function()
          return get_toolbar_buf()
        end,

        render = function()
          local buf = get_toolbar_buf()
          local toolbar = build_toolbar_lines()

          vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, toolbar.lines)
          vim.api.nvim_buf_clear_namespace(buf, toolbar_ns, 0, -1)

          for _, range in ipairs(toolbar.ranges[1]) do
            vim.api.nvim_buf_add_highlight(
              buf,
              toolbar_ns,
              range.hl,
              0,
              range.start_col,
              range.end_col
            )
          end

          for _, range in ipairs(toolbar.ranges[2]) do
            vim.api.nvim_buf_add_highlight(
              buf,
              toolbar_ns,
              range.hl,
              1,
              range.start_col,
              range.end_col
            )
          end

          vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
        end,

        allow_without_session = true,
      })

      dapui.setup({
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "▶",
        },

        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },

        expand_lines = true,

        layouts = {
          {
            position = "top",
            size = 2,
            elements = {
              {
                id = "toolbar",
                size = 1.0,
              },
            },
          },

          {
            position = "left",
            size = LEFT_WIDTH,
            elements = {
              {
                id = "repl",
                size = 0.40,
              },
              {
                id = "scopes",
                size = 0.25,
              },
              {
                id = "stacks",
                size = 0.25,
              },
              {
                id = "breakpoints",
                size = 0.10,
              },
            },
          },

          {
            position = "bottom",
            size = 10,
            elements = {
              {
                id = "console",
                size = 1.0,
              },
            },
          },
        },

        controls = {
          enabled = false,
          element = "toolbar",
        },

        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },

        windows = {
          indent = 1,
        },

        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
      })

      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = true,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
      })

      require("dap-python").setup("python3")
      require("dap-python").test_runner = "pytest"

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Python: current file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          justMyCode = true,
        },

        {
          type = "python",
          request = "launch",
          name = "Python: pytest current file",
          module = "pytest",
          args = {
            "-q",
            "${file}",
          },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          justMyCode = false,
        },
      }

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({
          reset = true,
        })
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
