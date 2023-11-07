local M = {
    -- A high-performance color highlighter for Neovim.
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
}

function M.config()
    require("colorizer").setup({
        filetypes = { "css", "sass", "scss", "html", "htm", "wgsl", "conf" },
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
