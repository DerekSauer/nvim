local indent_ok, indent = pcall(require, "indent_blankline")

if indent_ok then
    local config = {
        char = "┊",
        show_current_context = true,
        show_current_context_start = false,
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

    indent.setup(config)
else
    vim.notify("Failed to load plugin: indent_blankline.", vim.log.levels.ERROR)
end
