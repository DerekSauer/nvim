local M = {
    -- Indent guides
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
}

function M.config()
    local indent = require("indent_blankline")

    local config = {
        char = "┊",
        show_current_context = true,
        show_current_context_start = false,
        space_char_blankline = " ",
        use_treesitter = true,
        use_treesitter_scope = true,
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
            "IndentBlanklineIndent3",
            "IndentBlanklineIndent4",
            "IndentBlanklineIndent5",
            "IndentBlanklineIndent6",
        },
    }

    indent.setup(config)
end

return M
