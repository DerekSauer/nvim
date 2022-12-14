-- Rust-Analyzer LSP configuration
local M = {}

function M.setup(lsp_zero)
    lsp_zero.configure("rust_analyzer", {
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
