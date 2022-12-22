local default_colorscheme = "kanagawa"

local kanagawa_ok, kanagawa = pcall(require, "kanagawa")
if kanagawa_ok then
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
        overrides = {},
        theme = "default",
    }

    kanagawa.setup(config)
else
    vim.notify("Failed to load plugin: kanagawa.", vim.log.levels.ERROR)
    kanagawa = nil
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
