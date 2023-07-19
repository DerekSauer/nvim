local M = {}

---Setup my auto commands.
function M.setup_autocmds()
    local globals = require("globals")

    -- Briefly flash highlighted text when yanking it
    vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight on yank",
        group = globals.user_au_group,
        callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 200 }) end,
    })

    -- Allow closing the following buffer file types by pressing 'q'
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "man", "qf" },
        group = globals.user_au_group,
        command = "nnoremap <buffer> q <cmd>quit<cr>",
    })

    -- Normalize splits if the window size changes
    vim.api.nvim_create_autocmd("VimResized", {
        group = globals.user_au_group,
        command = "tabdo wincmd =",
    })
end

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

return M
