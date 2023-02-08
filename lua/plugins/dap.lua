local M = {
    -- Debug adapter protocol support
    "mfussenegger/nvim-dap",

    dependencies = {
        -- User interface for the DAP
        "rcarriga/nvim-dap-ui",

        -- Show variable values inline while debugging
        "theHamsta/nvim-dap-virtual-text",

        -- Better interop between DAP and Mason
        { "jay-babu/mason-nvim-dap.nvim", dependencies = { "williamboman/mason.nvim" } },
    },
}

---Configure dap-ui.
local function ui_config(dap)
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

    -- Show values inline with variables
    require("nvim-dap-virtual-text").setup({ all_frames = true })

    -- Add key map to toggle the debugger UI
    vim.keymap.set("n", "<leader>du", function() dapui.toggle({}) end,
        { desc = "Toggle debug UI" })

    -- Define icons and colors for breakpoints
    vim.fn.sign_define("DapBreakpoint",
        { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition",
        { text = "ﳁ", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected",
        { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })

end

---Config DAP keymap.
local function keymaps(dap)
    vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Debugger: Start/continue" })
    vim.keymap.set("n", "<F6>", function() dap.step_into() end, { desc = "Debugger: Step into" })
    vim.keymap.set("n", "<F7>", function() dap.step_over() end, { desc = "Debugger: Step over" })
    vim.keymap.set("n", "<F8>", function() dap.step_out() end, { desc = "Debugger: Step out" })
    vim.keymap.set("n", "<F9>", function() dap.toggle_breakpoint() end,
        { desc = "Debugger: Toggle breakpoint" })
    vim.keymap.set("n", "<F12>", function() dap.close() dap.terminate() require("dapui").close() end
        , { desc = "Debugger: Stop debugging" })
    vim.keymap.set("n", "<leader>ds", function() dap.continue() end, { desc = "Start/continue" })
    vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "Step into" })
    vim.keymap.set("n", "<leader>do", function() dap.step_over() end, { desc = "Step over" })
    vim.keymap.set("n", "<leader>dO", function() dap.step_out() end, { desc = "Step out" })
    vim.keymap.set("n", "<leader>dx",
        function() dap.close() dap.terminate() require("dapui").close() end,
        { desc = "Stop debugging" })
    vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end,
        { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<leader>dB",
        function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        { desc = "Conditional breakpoint" })
    vim.keymap.set("n", "<leader>dl",
        function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
        { desc = "Set log point" })
    vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "Toggle REPL" })

    require("which-key").register({
        d = { name = "Debugger" },
    }, { prefix = "<leader>" })
end

function M.config()
    local dap = require("dap")

    -- Initialize the 'mason' & 'nvim-dap' interop helper
    require("mason-nvim-dap").setup({ ensure_installed = { "codelldb" }, automatic_setup = true })

    -- Setup installed debug adapters
    require("mason-nvim-dap").setup_handlers({
        -- Default handler will automatically setup any DAP without a custom
        -- setup below. Automatic setup will enable an adapter with default settings.
        function(source_name)
            require("mason-nvim-dap.automatic_setup")(source_name)
        end,

        -- Override 'codelldb' with our own setup function
        codelldb = function()
            require("plugins/dap_adapters/codelldb").setup(dap)
        end,

        -- Example override
        -- python = function(source_name)
        --     dap.adapters.python = {
        --     }
        --
        --     dap.configurations.python = {
        --     }
        -- end,
    })

    -- Setup dap-ui
    ui_config(dap)

    -- Setup keymaps
    keymaps(dap)

    -- Map adapters to configurations for load_launchjs()
    local adapter_map = {
        codelldb = { "c", "cpp", "rust" },
    }

    -- Parse a ".vscode/launch.js" file if one is present in the workspace
    require("dap.ext.vscode").load_launchjs(nil, adapter_map)

    -- Autocommand to reparse the launch.json file if it changes
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = require("globals").user_au_group,
        pattern = { ".vscode/launch.json" },
        callback = function() require("dap.ext.vscode").load_launchjs(nil, adapter_map) end,
    })
end

return M
