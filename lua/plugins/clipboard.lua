local M = {
    -- Sync system clipboard with Neovim
    -- https://github.com/EtiamNullam/deferred-clipboard.nvim
    "EtiamNullam/deferred-clipboard.nvim",
    config = function() require("deferred-clipboard").setup() end,
}

return M
