local M = {}

-- Prefered border style for float windows
M.border_style = { "╒", "═", "╕", "│", "╛", "═", "╘", "│" }

-- Auto command group for our own commands
M.user_au_group = vim.api.nvim_create_augroup("user_cmds", { clear = true })

-- Briefly flash highlighted text when yanking it
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight on yank",
    group = M.user_au_group,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Allow closing the following buffer file types by pressing 'q'
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "man", "qf" },
    group = M.user_au_group,
    command = "nnoremap <buffer> q <cmd>quit<cr>",
})

return M
