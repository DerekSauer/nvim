local M = {
    -- Indent guides
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
}

function M.config()
    -- Highlight names from our colour scheme.
    local highlights = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
        "IndentBlanklineIndent7",
    }

    require("ibl").setup({
        indent = {
            highlight = highlights,
            char = "┊",
        },

        whitespace = {
            highlight = highlights,
        },

        scope = {
            enabled = true,
            char = "│",
            highlight = highlights,
        },
    })
end

return M
