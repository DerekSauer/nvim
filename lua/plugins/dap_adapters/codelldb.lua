local M = {}

---Configure the LLDB debug adapter.
---@param dap table Reference to a `nvim-dap` instance.
function M.setup(dap)
    -- Get the path to `codelldb` installed by Mason.
    local lldb_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension"
    local lldb_bin = lldb_path .. "/adapter/codelldb"

    if vim.fn.executable(lldb_bin) == 1 then
        dap.adapters.lldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = lldb_bin,
                args = { "--port", "${port}" },
            },
            enrich_config = function(config, on_config)
                -- If the configuration contains a `cargo` section
                -- send the configuration off to the cargo inspector.
                if config["cargo"] ~= nil then
                    on_config(require("plugins/dap_adapters/cargo_inspector").inspect(config))
                end
            end,
        }
    else
        vim.notify(
            "The codelldb debug adapter is not installed.\nPlease use Mason to install `codelldb`.",
            vim.log.levels.ERROR
        )
    end
end

return M
