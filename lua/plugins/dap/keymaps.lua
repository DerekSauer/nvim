local M = {}

function M.setup(dap)
    -- Setup debug key maps
    vim.keymap.set(
        "n",
        "<F5>",
        function() dap.continue() end,
        { silent = true, desc = "Debugger: Start/continue" }
    )
    vim.keymap.set(
        "n",
        "<F6>",
        function() dap.step_into() end,
        { silent = true, desc = "Debugger: Step into" }
    )
    vim.keymap.set(
        "n",
        "<F7>",
        function() dap.step_over() end,
        { silent = true, desc = "Debugger: Step over" }
    )
    vim.keymap.set(
        "n",
        "<F8>",
        function() dap.step_out() end,
        { silent = true, desc = "Debugger: Step out" }
    )
    vim.keymap.set(
        "n",
        "<F9>",
        function() dap.toggle_breakpoint() end,
        { silent = true, desc = "Debugger: Toggle breakpoint" }
    )
    vim.keymap.set("n", "<F12>", function()
        dap.disconnect({ restart = false, terminateDebuggee = true })
        dap.close()
    end, { silent = true, desc = "Debugger: Stop debugging" })

    vim.keymap.set(
        "n",
        "<leader>ds",
        function() dap.continue() end,
        { silent = true, desc = "Start/continue" }
    )
    vim.keymap.set(
        "n",
        "<leader>di",
        function() dap.step_into() end,
        { silent = true, desc = "Step into" }
    )
    vim.keymap.set(
        "n",
        "<leader>do",
        function() dap.step_over() end,
        { silent = true, desc = "Step over" }
    )
    vim.keymap.set(
        "n",
        "<leader>dO",
        function() dap.step_out() end,
        { silent = true, desc = "Step out" }
    )
    vim.keymap.set("n", "<leader>dx", function()
        dap.close()
        dap.terminate()
    end, { silent = true, desc = "Stop debugging" })
    vim.keymap.set(
        "n",
        "<leader>db",
        function() dap.toggle_breakpoint() end,
        { silent = true, desc = "Toggle breakpoint" }
    )
    vim.keymap.set(
        "n",
        "<leader>dB",
        function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        { silent = true, desc = "Conditional breakpoint" }
    )
    vim.keymap.set(
        "n",
        "<leader>dl",
        function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
        { silent = true, desc = "Set log point" }
    )
    vim.keymap.set(
        "n",
        "<leader>dr",
        function() dap.repl.toggle() end,
        { silent = true, desc = "Toggle REPL" }
    )

    require("which-key").register({
        d = { name = "Debugger" },
    }, { prefix = "<leader>" })
end

return M
