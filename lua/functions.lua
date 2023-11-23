local M = {}

function M.setup()
    -- Swap between light and dark colour schemes.
    local function swap_background()
        if vim.opt.background._value == "dark" then
            vim.cmd("set background=light")
        else
            vim.cmd("set background=dark")
        end
    end

    -- Key map to swap between light and dark colour schemes (LEADER+c).
    vim.keymap.set("n", "<leader>c", function()
        swap_background()
    end, { silent = true, desc = "Swap light/dark theme" })
end

return M
