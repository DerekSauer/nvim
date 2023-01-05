local dap_ok, dap = pcall(require, "dap")

if dap_ok then
    -- Setup Dap-UI
    require("plugin-config/dap-config/dapui").setup(dap)

    -- Setup keymaps
    require("plugin-config/dap-config/keymaps").setup(dap)

    -- Setup the lldb debug adapter for C, CPP, and Rust
    require("plugin-config/dap-config/lldb").setup(dap)

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
else
    vim.notify("Failed to load plugin: dap", vim.log.levels.ERROR)
end
