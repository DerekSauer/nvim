-- Sumneko_lua LSP configuration
local M = {}

function M.setup(lsp_zero)
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    lsp_zero.configure("sumneko_lua", {
        settings = {
            Lua = {
                format = {
                    enable = true,
                    defaultConfig = {
                        indent_style = "space",
                        indent_size = "4",
                        tab_width = "4",
                        quote_style = "double",
                        end_of_line = "unset",
                        call_arg_parentheses = "keep",
                        table_separator_style = "comma",
                        trailing_table_separator = "smart",
                        max_line_length = 120,
                        continuous_assign_statement_align_to_equal_sign = false,
                        continuous_assign_table_field_align_to_equal_sign = false,
                    },
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
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return M
