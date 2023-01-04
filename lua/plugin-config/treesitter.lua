local treesitter_ok, treesitter = pcall(require, "nvim-treesitter.configs")

if treesitter_ok then
    treesitter.setup({
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

        -- Enable auto-closing HTMl tags
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
else
    vim.notify("Failed to load plugin: tree-sitter.", vim.log.levels.ERROR)
end
