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

        languages = {
            lua = {
                template = {
                    annotation_convention = "emmylua",
                },
            },
        },
    }

    neogen.setup(config)

    vim.keymap.set("n", "<leader>t", ":Neogen<CR>", { silent = true, desc = "Annotate code" })
end

return M
