local M = {}

function M.setup(lsp_config, lsp_capabilities)
    lsp_config.rust_analyzer.setup({
        capabilities = lsp_capabilities,

        settings = {
            ["rust-analyzer"] = {
                checkOnSave = true,
                check = {
                    command = "clippy",
                },
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                inlayHints = {
                    enable = true,
                },
                lens = {
                    enable = false,
                },
            },
        },
    })
end

return M
