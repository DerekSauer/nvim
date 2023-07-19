local M = {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
            comments = { "italic" },
            conditionals = { "italic" },
        },
        integrations = {
            cmp = true,
            dap = {
                enabled = true,
                enable_ui = true,
            },
            indent_blankline = {
                enabled = true,
                colored_indent_levels = true,
            },
            gitsigns = true,
            treesitter = true,
            mason = true,
            native_lsp = {
                enabled = true,
                inlay_hints = {
                    background = true,
                },
            },
            neotree = false,
            notify = true,
            symbols_outline = true,
            telescope = {
                enabled = true,
            },
            which_key = true,
        },
    })
end

return M
