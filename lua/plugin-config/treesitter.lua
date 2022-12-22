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

        -- Enable rainbox parens
        rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = 1000,
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

    -- Autocommand to disable TS-rainbow prior to saving the buffer
    -- I automatically format buffers on save and this frequently confuses TS-rainbow
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = { "*" },
        command = "TSDisable rainbow",
    })

    -- Autocommand to reenable TS-rainbow after writing (and formatting) the buffer
    -- This will reset any misplaced paren colors
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*" },
        command = "TSEnable rainbow",
    })

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false
else
    vim.notify("Failed to load plugin: tree-sitter.", vim.log.levels.ERROR)
end
