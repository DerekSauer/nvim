local M = {
    -- Lightbulb 💡icon in the gutter when code action is available.
    -- https://github.com/kosayoda/nvim-lightbulb
    "kosayoda/nvim-lightbulb",
    config = function() require("nvim-lightbulb").setup({ autocmd = { enabled = true } }) end,
}

return M
