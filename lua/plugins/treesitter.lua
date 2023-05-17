local M = {
    -- Nvim Treesitter configurations and abstraction layer
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        -- Autoclose HTML,CSS tags
        -- https://github.com/windwp/nvim-ts-autotag
        "windwp/nvim-ts-autotag",

        -- Automatically add closing operators to textual languages (Lua, Ruby, etc...)
        -- https://github.com/RRethy/nvim-treesitter-endwise
        "RRethy/nvim-treesitter-endwise",

        -- Rainbow parens
        {
            url = "https://gitlab.com/HiPhish/nvim-ts-rainbow2",
            name = "nvim-ts-rainbow2",
        },
    },
}

function M.config()
    require("nvim-treesitter.configs").setup({
        -- Install Tree-Sitter syntaxes automatically when missing
        auto_install = true,
        -- Make sure the following syntaxes are always installed
        ensure_installed = { "lua", "vim", "vimdoc", "markdown", "rust", "toml" },
        -- Enable the syntax highlighting module
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        -- Enable the indent helper module
        indent = {
            enable = true,
        },
        -- Enable auto-closing HTMl tags
        autotag = {
            enable = true,
        },
        -- Enable auto-closing language structures
        endwise = {
            enable = true,
        },

        rainbow = {
            enable = true,
        }
    })

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false
end

return M
