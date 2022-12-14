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

-- Trim the working directory from a buffer name
--- Trim the current working directory from a buffer name.
---@param bufnr number @Buffer number who's name we want trimmed.
---@return string @The name of the with the current working directory removed.
function M.trimmed_buffer_name(bufnr)
    local trimmed_buffer, _ = string.gsub(vim.fn.bufname(bufnr), vim.fn.getcwd(), ".")
    return trimmed_buffer
end

--- Gets a list of "listed" buffers.
--- @return table @An array of "listed" buffers.
function M.get_listed_buffers()
    local buffers = {}
    local len = 0
    local buflisted = vim.fn.buflisted

    for buffer = 1, vim.fn.bufnr("$") do
        if buflisted(buffer) == 1 then
            len = len + 1
            buffers[len] = buffer
        end
    end

    return buffers
end

return M
