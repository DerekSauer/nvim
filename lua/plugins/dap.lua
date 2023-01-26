local M = {
    -- Debug adapter
    -- https://github.com/mfussenegger/nvim-dap
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
    },
}

function M.config()
    local dap = require("dap")

    -- Setup dap-ui
    require("plugins/dap/ui").setup(dap)

    -- Setup keymaps
    require("plugins/dap/keymaps").setup(dap)

    -- Setup the lldb debug adapter for C, CPP, and Rust
    require("plugins/dap/lldb").setup(dap)

    -- Map adapters to configurations for load_launchjs()
    local adapter_map = {
        lldb = { "c", "cpp", "rust" },
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
