require("nvim-treesitter.configs").setup({
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    
    indent = {
        enable = true,
    },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
