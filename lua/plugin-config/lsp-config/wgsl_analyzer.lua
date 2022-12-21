local M = {}

function M.setup(lsp_zero) lsp_zero.configure("wgsl_analyzer", {}) end

-- Autocommand to reparse the launch.json file if it changes
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.wgsl" },
    command = "set filetype=wgsl",
})

return M
