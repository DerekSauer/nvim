local loaded, indent_blankline = pcall(require, "indent_blankline")

if loaded then
    local config = {
        char = "┊",
        show_current_context = true,
        show_current_context_start = true,
        space_char_blankline = " ",
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
            "IndentBlanklineIndent3",
            "IndentBlanklineIndent4",
            "IndentBlanklineIndent5",
            "IndentBlanklineIndent6",
        },
    }

    indent_blankline.setup(config)
else
    vim.notify("Failed to load plugin: indent_blankline.", vim.log.levels.ERROR)
    indent_blankline = nil
end
