local M = {
    -- Indent guides
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    "lukas-reineke/indent-blankline.nvim",
    branch = "v3"
}

function M.config()
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
            remove_blank_line_trail = false
        },

        scope = {
            enabled = true,
            char = "│",
            highlight = highlights
        }
    })
end

return M
