local M = {
    -- Zen-mode distraction free coding
    -- https://github.com/folke/zen-mode.nvim
    "folke/zen-mode.nvim",
}

function M.config()
    require("zen-mode").setup()

    -- Key mapping
    vim.keymap.set(
        "n",
        "<leader>z",
        function() require("zen-mode").toggle() end,
        { silent = true, desc = "Toggle zenmode" }
    )
end

return M
