local M = {
    "NvChad/nvim-colorizer.lua",
}

function M.config()
    require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
            mode = "virtualtext",
            virtualtext = "",
            RGB = false,
            RRGGBB = true,
            RRGGBBAA = true,
            AARRGGBB = true,
            names = false,
            css = true,
            sass = { enable = true, parsers = { "css" } },
        },
    }
    )
end

return M
