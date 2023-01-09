local M = {
    -- Escape from insert mode without delay when typing
    -- https://github.com/max397574/better-escape.nvim
    "max397574/better-escape.nvim",
    config = function() require("better_escape").setup() end,
}

return M
