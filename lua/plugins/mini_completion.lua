local M = {
    "echasnovski/mini.completion",
    version = false,
}

function M.config()
    local borders = require("globals").border_style

    require("mini.completion").setup({
        -- Add a border to the completion popup windows.
        window = {
            info = { width = 80, height = 25, border = borders },
            signature = { width = 80, height = 25, border = borders },
        },
    })

    -- Jump forward through the completion list with Tab.
    vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })

    -- Jump backwards in the completion list with Shift-Tab.
    vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

    -- Map textual representations of completion menu commands to their internal Neovim representation.
    local keys = {
        ["cr"] = vim.api.nvim_replace_termcodes("<CR>", true, true, true),
        ["ctrl-y"] = vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
        ["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<C-y><CR>", true, true, true),
    }

    -- Helper function to improve the behavior of `Enter` when interacting with the completion menu.
    _G.cr_action = function()
        if vim.fn.pumvisible() ~= 0 then
            -- If popup is visible, confirm selected item or add new line otherwise
            local item_selected = vim.fn.complete_info()["selected"] ~= -1
            return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
        else
            -- If popup is not visible, use plain `<CR>`.
            -- TODO: Replace this with `return require('mini.pairs').cr()` if using mini.pairs.
            return keys["cr"]
        end
    end

    -- Use the above function when pressing `Enter`.
    vim.keymap.set("i", "<CR>", "v:lua._G.cr_action()", { expr = true })
end

return M
