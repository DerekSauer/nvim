local M = {
    "sam4llis/nvim-tundra",
    lazy = false,
    priority = 1000,
}

function M.config()
    require("nvim-tundra").setup({
        transparent_background = false,
        dim_inactive_windows = {
            enabled = true,
            color = nil,
        },
        sidebars = {
            enabled = true,
            color = nil,
        },
        editor = {
            search = {},
            substitute = {},
        },
        syntax = {
            booleans = { bold = true, italic = true },
            comments = { bold = false, italic = true },
            conditionals = {},
            constants = { bold = true },
            fields = {},
            functions = {},
            keywords = {},
            loops = {},
            numbers = { bold = true },
            operators = { bold = true },
            punctuation = {},
            strings = {},
            types = { italic = true },
        },
        diagnostics = {
            errors = {},
            warnings = {},
            information = {},
            hints = {},
        },
        plugins = {
            lsp = true,
            semantic_tokens = true,
            treesitter = true,
            telescope = true,
            cmp = true,
            gitsigns = true,
        },
        overwrite = {
            colors = {},
            highlights = {},
        },
    })
end

return M
