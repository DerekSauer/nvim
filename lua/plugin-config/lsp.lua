local loaded, lsp = pcall(require, "lsp-zero")

if loaded then
    lsp.preset("recommended")
    lsp.nvim_workspace()

    -- Setup lua-language-server
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    lsp.configure("sumneko_lua", {
        settings = {
            Lua = {
                format = {
                    enable = false,
                },
                runtime = {
                    version = "LuaJIT",
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })

    lsp.setup()
else
    vim.notify("Failed to load plugin: lsp-zero.", vim.log.levels.ERROR)
end
