local M = {}

--- Install `lazy.nvim` if not found.
local function bootstrap_lazy()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
end

function M.setup()
    -- Install `lazy.nvim` if needed.
    bootstrap_lazy()

    require("lazy").setup("plugins", {
        -- Automatically check for plugin updates every four hours.
        checker = {
            enabled = true,
            notify = false,
            frequency = 14400,
        },

        -- Use the global border style and reduce the window size slighty.
        ui = {
            border = require("globals").border_style,
            size = { width = 0.75, height = 0.75 },
        },

        -- Try to load our color scheme when Lazy is synching plugins on load.
        install = {
            colorscheme = { "kanagawa" },
        },

        -- Disable watching for changes to our plugin configuration.
        -- I always have to reload Neovim anyway after modifying plugins.
        change_detection = {
            enabled = false,
        },

        -- Disable some built-in plugins I never use.
        performance = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },

        -- Disable profiling. Reenable when debugging.
        profiling = {
            loader = false,
            require = false,
        },
    })
end

return M
