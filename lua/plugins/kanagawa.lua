local M = {
    -- Colorscheme inspired by the colors of the famous painting by Katsushika Hokusai
    -- https://github.com/rebelot/kanagawa.nvim
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
                -- Add kanagawa colors to Navic
                NavicIconsFile = { link = "Directory" },
                NavicIconsModule = { link = "TSInclude" },
                NavicIconsNamespace = { link = "TSInclude" },
                NavicIconsPackage = { link = "TSInclude" },
                NavicIconsClass = { link = "Structure" },
                NavicIconsMethod = { link = "Function" },
                NavicIconsProperty = { link = "TSProperty" },
                NavicIconsField = { link = "TSField" },
                NavicIconsConstructor = { link = "@constructor" },
                NavicIconsEnum = { link = "Identifier" },
                NavicIconsInterface = { link = "Type" },
                NavicIconsFunction = { link = "Function" },
                NavicIconsVariable = { link = "@variable" },
                NavicIconsConstant = { link = "Constant" },
                NavicIconsString = { link = "String" },
                NavicIconsNumber = { link = "Number" },
                NavicIconsBoolean = { link = "Boolean" },
                NavicIconsArray = { link = "Type" },
                NavicIconsObject = { link = "Type" },
                NavicIconsKey = { link = "Keyword" },
                NavicIconsNull = { link = "Type" },
                NavicIconsEnumMember = { link = "TSField" },
                NavicIconsStruct = { link = "Structure" },
                NavicIconsEvent = { link = "Structure" },
                NavicIconsOperator = { link = "Operator" },
                NavicIconsTypeParameter = { link = "Identifier" },
                NavicText = { fg = theme.ui.fg },
                NavicSeparator = { fg = theme.ui.fg },
                -- Indent Blankline rainbow colors
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
