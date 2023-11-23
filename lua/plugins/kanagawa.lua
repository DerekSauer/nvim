local M = {
    -- Color scheme inspired by the colours of the famous painting by Katsushika Hokusai.
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    require("kanagawa").setup({
        compile = true,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = true,
        terminalColors = true,
        theme = "wave",
        background = {
            dark = "wave",
            light = "lotus",
        },
        overrides = function(colors)
            local theme = colors.theme
            return {
                -- Apply Kanagawa to picker menus
                Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                PmenuSbar = { bg = theme.ui.bg_m1 },
                PmenuThumb = { bg = theme.ui.bg_p2 },

                -- `Indent Blankline` indent colours
                IndentBlanklineIndent1 = { fg = theme.term[17] },
                IndentBlanklineIndent2 = { fg = theme.term[3] },
                IndentBlanklineIndent3 = { fg = theme.term[4] },
                IndentBlanklineIndent4 = { fg = theme.term[5] },
                IndentBlanklineIndent5 = { fg = theme.term[6] },
                IndentBlanklineIndent6 = { fg = theme.term[7] },
                IndentBlanklineIndent7 = { fg = theme.term[8] },
            }
        end,
        colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "none",
                    },
                },
            },
        },
    })
end

return M
