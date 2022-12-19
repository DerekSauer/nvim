local M = {}

function M.setup(dap)
    local dapui_ok, dapui = pcall(require, "dapui")
    if dapui_ok then
        local globals = require("globals")
        local dap_ui_config = {
            expand_lines = true,

            floating = {
                border = globals.border_style,
            },

            controls = {
                enabled = true,
            },
        }
        dapui.setup(dap_ui_config)

        -- Setup event listeners to open and close dap-ui when the debugger starts & stops
        dap.listeners.after.event_initialized["dap_ui_config"] = function()
            -- Close neo-tree before opening dap-ui, it takes up a lot of space
            local neo_tree_ok, _ = pcall(require, "neo-tree")
            if neo_tree_ok then vim.cmd(":Neotree close") end
            dapui.open({})
        end
        dap.listeners.before.event_terminated["dap_ui_config"] = function() dapui.close({}) end
        dap.listeners.before.event_exited["dap_ui_config"] = function() dapui.close({}) end
        dap.listeners.before.disconnect["dap_ui_config"] = function() dapui.close({}) end

        -- Add key map to toggle the debugger UI
        vim.keymap.set(
            "n",
            "<leader>du",
            function() dapui.toggle({}) end,
            { silent = true, desc = "Toggle debug UI" }
        )
    end

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
    vim.fn.sign_define(
        "DapLogPoint",
        { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DapStopped", linehl = "", numhl = "" }
    )

    -- Setup Dap virtual text
    local dap_vt_ok, dap_vt = pcall(require, "nvim-dap-virtual-text")
    if dap_vt_ok then
        local dap_vt_config = {
            all_frames = true,
        }
        dap_vt.setup(dap_vt_config)
    end
end

return M
