local M = {
    -- Smart code commenting
    -- https://github.com/numToStr/Comment.nvim
    "numToStr/Comment.nvim",
    event = "VeryLazy",
}

function M.config()
    -- Disable Comment's default keymaps, we'll define our own below
    require("Comment").setup({ mappings = { basic = false, extra = false } })

    -- <leader>+/ in normal mode to toggle comment on current line
    vim.keymap.set(
        "n",
        "<leader>/",
        function() require("Comment.api").toggle.linewise.current() end,
        { desc = "Toggle comment" }
    )

    -- <leader>+/ in visual mode to toggle comment on a selection
    vim.keymap.set(
        "v",
        "<leader>/",
        "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        { desc = "Toggle comment" }
    )
end

return M
