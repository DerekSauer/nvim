local M = {
    -- Colorscheme inspired by the colors of the famous painting by Katsushika Hokusai
    -- https://github.com/rebelot/kanagawa.nvim
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
}

function M.config()
    local kanagawa = require("kanagawa")
    local default_colors = require("kanagawa.colors").setup()

    -- Define highlight overrides
    local hl_overrides = {
        NavicIconsFile = { fg = default_colors.springViolet2 },
        NavicIconsModule = { fg = default_colors.boatYellow2 },
        NavicIconsNamespace = { fg = default_colors.springViolet2 },
        NavicIconsPackage = { fg = default_colors.springViolet1 },
        NavicIconsClass = { fg = default_colors.surimiOrange },
        NavicIconsMethod = { fg = default_colors.crystalBlue },
        NavicIconsProperty = { fg = default_colors.waveAqua2 },
        NavicIconsField = { fg = default_colors.waveAqua1 },
        NavicIconsConstructor = { fg = default_colors.surimiOrange },
        NavicIconsEnum = { fg = default_colors.boatYellow2 },
        NavicIconsInterface = { fg = default_colors.carpYellow },
        NavicIconsFunction = { fg = default_colors.crystalBlue },
        NavicIconsVariable = { fg = default_colors.oniViolet },
        NavicIconsConstant = { fg = default_colors.oniViolet },
        NavicIconsString = { fg = default_colors.springGreen },
        NavicIconsNumber = { fg = default_colors.sakuraPink },
        NavicIconsBoolean = { fg = default_colors.surimiOrange },
        NavicIconsArray = { fg = default_colors.waveAqua2 },
        NavicIconsObject = { fg = default_colors.surimiOrange },
        NavicIconsKey = { fg = default_colors.oniViolet },
        NavicIconsNull = { fg = default_colors.carpYellow },
        NavicIconsEnumMember = { fg = default_colors.carpYellow },
        NavicIconsStruct = { fg = default_colors.surimiOrange },
        NavicIconsEvent = { fg = default_colors.surimiOrange },
        NavicIconsOperator = { fg = default_colors.springViolet2 },
        NavicIconsTypeParameter = { fg = default_colors.springBlue },
        NavicText = { fg = default_colors.fujiWhite },
        NavicSeparator = { fg = default_colors.fujiWhite },

        -- Indent Blankline rainbow colors
        IndentBlanklineIndent1 = { fg = default_colors.waveAqua1 },
        IndentBlanklineIndent2 = { fg = default_colors.surimiOrange },
        IndentBlanklineIndent3 = { fg = default_colors.dragonBlue },
        IndentBlanklineIndent4 = { fg = default_colors.waveRed },
        IndentBlanklineIndent5 = { fg = default_colors.springViolet1 },
        IndentBlanklineIndent6 = { fg = default_colors.springGreen },
        IndentBlanklineIndent7 = { fg = default_colors.springBlue },
    }

    local config = {
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        variablebuiltinStyle = { italic = true },
        specialReturn = true, -- special highlight for the return keyword
        specialException = true, -- special highlight for exception handling keywords
        transparent = false, -- do not set background color
        dimInactive = true, -- dim inactive window `:h hl-NormalNC`
        globalStatus = true, -- adjust window separators highlight for laststatus=3
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = {},
        overrides = hl_overrides,
        theme = "default",
    }

    kanagawa.setup(config)
    vim.cmd.colorscheme("kanagawa")

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
end

return M
