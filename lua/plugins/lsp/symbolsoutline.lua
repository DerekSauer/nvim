local M = {}

function M.setup()
    local config = {}

    require("symbols-outline").setup()

    vim.keymap.set(
        "n",
        "<leader>o",
        function() vim.cmd("SymbolsOutline") end,
        { silent = true, desc = "Toggle symbol outline" }
    )
end

return M
