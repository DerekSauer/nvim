local M = {
    -- Neovim Tree sitter configurations and abstraction layer.
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        -- Auto close HTML, CSS tags.
        "windwp/nvim-ts-autotag",

        -- Automatically add closing operators to textual languages (Lua, Ruby, etc…).
        "RRethy/nvim-treesitter-endwise",
    },
}

function M.config()
    require("nvim-treesitter.configs").setup({
        -- Install Tree-Sitter syntaxes automatically when missing
        auto_install = true,

        -- Enable the syntax highlighting module
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },

        -- Enable the indent helper module
        indent = {
            enable = true,
        },

        -- Enable auto-closing HTML tags
        autotag = {
            enable = true,
        },

        -- Enable auto-closing language structures
        endwise = {
            enable = true,
        },
    })

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false
end

return M
