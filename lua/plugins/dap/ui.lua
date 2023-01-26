local M = {}

function M.setup(dap)
    local dapui = require("dapui")

    local dap_ui_config = {
        expand_lines = true,

        floating = {
            border = require("globals").border_style,
        },

        controls = {
            enabled = true,
        },
    }
    dapui.setup(dap_ui_config)

    -- Setup event listeners to open and close dap-ui when the debugger starts & stops
    dap.listeners.after.event_initialized["dap_ui_config"] = function()
        -- Close neo-tree before opening dap-ui, it takes up a lot of space
        vim.cmd(":Neotree close")
        dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    -- Setup dap virtual texts
    local dap_vt_config = {
        all_frames = true,
    }
    require("nvim-dap-virtual-text").setup(dap_vt_config)

    -- Add key map to toggle the debugger UI
    vim.keymap.set(
        "n",
        "<leader>du",
        function() dapui.toggle({}) end,
        { silent = true, desc = "Toggle debug UI" }
    )

    -- Define icons and colors for breakpoints
    vim.fn.sign_define(
        "DapBreakpoint",
        { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "ﳁ", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })
end

return M
