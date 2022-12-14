local M = {}

function M.setup(dap)
    -- Get the path to `codelldb` installed by Mason.nvim
    local lldb_path = require("mason-registry").get_package("codelldb"):get_install_path()
        .. "/extension"
    local lldb_bin = lldb_path .. "/adapter/codelldb"

    if vim.fn.executable(lldb_bin) == 1 then
        -- Configure the LLDB adapter
        dap.adapters.lldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = lldb_bin,
                args = { "--port", "${port}" },
            },
            enrich_config = function(config, on_config)
                -- If the configuration(s) in `launch.json` contains a `cargo` section
                -- send the configuration off to the cargo_inspector.
                if config["cargo"] ~= nil then
                    on_config(require("plugins/dap/cargo_inspector").inspect(config))
                end
            end,
        }
    else
        vim.notify(
            "The codelldb debug adapter is not installed.\nPlease use Mason to install `codelldb`.",
            vim.log.levels.ERROR
        )
        return {}
    end
end

return M
