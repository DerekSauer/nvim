local M = {
    -- LSP status indicator.
    "j-hui/fidget.nvim",
}

function M.config()
    require("fidget").setup()
end

return M
