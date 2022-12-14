local neogen_ok, neogen = pcall(require, "neogen")

if neogen_ok then
    local config = {
        snippet_engine = "luasnip",
    }

    neogen.setup(config)

    vim.keymap.set("n", "<leader>t", ":Neogen<CR>", { silent = true, desc = "Annotate code" })
else
    vim.notify("Failed to load plugin: neogen.", vim.log.levels.ERROR)
    neogen = nil
end
