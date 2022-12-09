local loaded, catppuccin = pcall(require, "catppuccin")

if not loaded then
    vim.notify("Failed to load plugin: catppuccin.", vim.log.levels.ERROR)
    catppuccin = nil
end

if catppuccin then
    local config = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false,
        term_colors = true,
        dim_inactive = {
            enabled = true,
            shade = "dark",
            percentage = 0.25,
        },

        styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = { "bold" },
            keywords = { "bold" },
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
            -- https://github.com/catppuccin/nvim#integrations
        },
    }

    catppuccin.setup(config)
    vim.cmd.colorscheme("catppuccin")

    -- Function and keymap to swap light & dark color schemes
    local function swap_background()
        if vim.opt.background._value == "dark" then
            vim.cmd("set background=light")
        else
            vim.cmd("set background=dark")
        end
    end
    vim.keymap.set('n', "<leader>c", function() swap_background() end, { silent = true, desc = "Swap light/dark theme" })
end
