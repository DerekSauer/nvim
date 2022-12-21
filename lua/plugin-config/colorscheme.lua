local default_colorscheme = "catppuccin"

-- Catppuccin setup
local catppuccin_ok, catppuccin = pcall(require, "catppuccin")
if catppuccin_ok then
    local config = {
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = {
            light = "latte",
            dark = "macchiato",
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
        custom_highlights = function(colors)
            local options = require("catppuccin").options
            return {
                WinBar = {
                    fg = colors.rosewater,
                    bg = options.transparent_background and colors.none or colors.mantle,
                },
                ["LspInlayHint"] = {
                    fg = colors.surface0,
                    bg = colors.base,
                },
            }
        end,
        integrations = {
            -- https://github.com/catppuccin/nvim#integrations
            gitsigns = true,
            mason = true,
            cmp = true,
            treesitter = true,
            ts_rainbow = true,
            telescope = true,
            which_key = true,

            dap = {
                enabled = true,
                enable_ui = true, -- enable nvim-dap-ui
            },

            indent_blankline = {
                enabled = true,
                colored_indent_levels = true,
            },

            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                },
            },

            navic = {
                enabled = true,
                custom_bg = "NONE",
            },
        },
    }

    catppuccin.setup(config)
else
    vim.notify("Failed to load plugin: catppuccin.", vim.log.levels.ERROR)
    catppuccin = nil
end

vim.cmd.colorscheme(default_colorscheme)

-- Function and keymap to swap light & dark color schemes
local function swap_background()
    if vim.opt.background._value == "dark" then
        vim.cmd("set background=light")
    else
        vim.cmd("set background=dark")
    end
end

vim.keymap.set(
    "n",
    "<leader>c",
    function() swap_background() end,
    { silent = true, desc = "Swap light/dark theme" }
)
