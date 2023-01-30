local M = {}

function M.setup(lsp_config, lsp_capabilities)
    lsp_config.rust_analyzer.setup({
        capabilities = lsp_capabilities,

        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
                lens = {
                    enable = false,
                },
            },
        },
    })
end

return M
