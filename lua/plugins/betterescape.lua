local M = {
    -- Escape from insert mode without delay when typing.
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    config = function() require("better_escape").setup() end,
}

return M
