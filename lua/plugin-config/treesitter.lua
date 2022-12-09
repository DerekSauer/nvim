local loaded, treesitter = pcall(require, "nvim-treesitter")

if not loaded then
    vim.notify("Failed to load plugin: tree-sitter.", vim.log.levels.ERROR)
    treesitter = nil
end

if treesitter then
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

        -- Enable rainbox parens
        rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = 1000
        },

        -- Enable auto-closing HTMl tags
        autotag = {
            enable = true
        }
    })

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false
end
