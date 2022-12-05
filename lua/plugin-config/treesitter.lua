require("nvim-treesitter.configs").setup({
    -- Install Tree-Sitter syntaxes automatically when missing
    auto_install = true,

    -- Enable the syntax highlighting module
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },

    -- Enable the indent helper module
    indent = {
        enable = true,
    },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
