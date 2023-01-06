local M = {
    -- Easy code annotations.
    -- https://github.com/danymat/neogen/
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
}

function M.config()
    local neogen = require("neogen")

    local config = {
        snippet_engine = "luasnip",
    }

    neogen.setup(config)

    vim.keymap.set("n", "<leader>t", ":Neogen<CR>", { silent = true, desc = "Annotate code" })
end

return M
