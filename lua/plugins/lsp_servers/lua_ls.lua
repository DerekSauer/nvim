local M = {}

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

function M.setup(lsp_config, lsp_capabilities)
    lsp_config.lua_ls.setup({
        capabilities = lsp_capabilities,
        single_file_support = true,
        settings = {
            Lua = {
                format = {
                    enable = true,

                    -- Values must be strings!
                    defaultConfig = {
                        indent_style = "space",
                        indent_size = "4",
                        tab_width = "4",
                        quote_style = "double",
                        end_of_line = "unset",
                        call_arg_parentheses = "keep",
                        table_separator_style = "comma",
                        trailing_table_separator = "smart",
                        max_line_length = "100",
                    },
                },
                hint = {
                    enable = true,
                },
                runtime = {
                    version = "LuaJIT",
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    checkThirdParty = false,
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return M
