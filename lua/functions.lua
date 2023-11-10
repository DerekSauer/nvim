local M = {}

---Setup my functions.
function M.setup()
    -- Function and keymap to swap light & dark color schemes.
    local function swap_background()
        if vim.opt.background._value == "dark" then
            vim.cmd("set background=light")
        else
            vim.cmd("set background=dark")
        end
    end

    -- Keymap to swap light & dark color schemes.
    vim.keymap.set("n", "<leader>c", function()
        swap_background()
    end, { silent = true, desc = "Swap light/dark theme" })
end

return M
