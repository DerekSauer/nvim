local M = {
    -- LSP status indicator.
    "j-hui/fidget.nvim",
}

function M.config()
    require("fidget").setup({
        progress = {
            lsp = {
                progress_ringbuf_size = 2048,
            },
        },
    })
end

return M
