local M = {}

function M.setup(bufnr)
    require("symbols-outline").setup()

    vim.keymap.set(
        "n",
        "<leader>o",
        function() vim.cmd("SymbolsOutline") end,
        { silent = true, buffer = bufnr, desc = "Toggle symbol outline" }
    )
end

return M
