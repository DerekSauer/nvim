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
        checker = {
            enabled = true,
            notify = false,
            frequency = 14400,
        },
        ui = {
            border = require("globals").border_style,
            size = { width = 0.75, height = 0.75 },
        },
    })
end

return M
