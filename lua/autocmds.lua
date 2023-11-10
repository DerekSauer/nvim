local M = {}

---Setup my auto commands.
function M.setup()
    local yank_highlight_group = vim.api.nvim_create_augroup("yank_highlight", { clear = true })

    -- Briefly flash highlighted text when yanking it.
    vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Briefly highlight yanked text",
        group = yank_highlight_group,
        callback = function()
            vim.highlight.on_yank({ higroup = "Visual", timeout = 300 })
        end,
    })

    -- Save current cursor position whenever it is moved.
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        pattern = "*",
        desc = "Save previous cursor position when the cursor is moved.",
        group = yank_highlight_group,
        callback = function()
            vim.g.current_cursor_pos = vim.fn.getcurpos()
        end,
    })

    -- When yanking a block of text, vim moves the cursor to the start of the block after the yank.
    -- Move cursor to end of block after yanking so the cursor doesn't actually move.
    vim.api.nvim_create_autocmd("TextYankPost", {
        pattern = "*",
        desc = "Move cursor to the end of a block of yanked text",
        group = yank_highlight_group,
        callback = function()
            if vim.v.event.operator == "y" then
                vim.fn.setpos(".", vim.g.current_cursor_pos)
            end
        end,
    })

    -- Allow closing the following buffer file types by pressing 'q'.
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "man", "qf" },
        desc = "Close certain buffers by pressing 'q'",
        group = vim.api.nvim_create_augroup("quick_close_windows", { clear = true }),
        command = "nnoremap <buffer> q <cmd>quit<cr>",
    })

    -- Normalize splits if the window size changes.
    vim.api.nvim_create_autocmd("VimResized", {
        desc = "Resize splits when vim's window size changes",
        group = vim.api.nvim_create_augroup("window_resize", { clear = true }),
        command = "wincmd =",
    })
end

return M
