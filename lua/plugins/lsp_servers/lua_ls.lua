local M = {}


--- Find the path(s) of Neovim's Lua Runtime.
---@return string[]
local function get_lua_runtime()
    local result = {}

    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
        local lua_path = path .. "/lua/"

        if vim.fn.isdirectory(lua_path) then
            table.insert(result, lua_path)
        end
    end

    table.insert(result, vim.fn.expand("$VIMRUNTIME/lua"))

    return result
end

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
                    arrayIndex = "Disable",
                    setType = true,
                },
                completion = {
                    keywordSnippet = "Disable",
                    callSnippet = "Replace",
                },
                runtime = {
                    version = "LuaJIT",
                    path = { "?.lua", "?/init.lua" },
                },
                diagnostics = {
                    enable = true,
                    globals = { "vim", "s", "i", "fmt", "rep", "conds", "f", "c", "t" },
                },
                workspace = {
                    checkThirdParty = "Disable",
                    library = get_lua_runtime(),
                    maxPreload = 10000,
                    preloadFileSize = 10000,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return M
