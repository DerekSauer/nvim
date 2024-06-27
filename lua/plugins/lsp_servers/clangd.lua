local M = {}

function M.setup(lsp_config, lsp_capabilities)
    lsp_config.clangd.setup({
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=bundled",
            "--cross-file-rename",
            "--header-insertion=iwyu",
        },

        capabilities = lsp_capabilities,
    })
end

return M
