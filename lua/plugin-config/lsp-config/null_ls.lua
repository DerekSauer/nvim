local M = {}

function M.setup(lsp_zero)
    local null_ls_ok, null_ls = pcall(require, "null-ls")

    local null_ls_options = lsp_zero.build_options("null-ls", {})
    if null_ls_ok then
        local null_ls_config = {
            on_attach = null_ls_options.on_attach,
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.diagnostics.selene,
            },
        }

        null_ls.setup(null_ls_config)
    else
        vim.notify("Failed to setup plugin: null-ls.", vim.log.levels.ERROR)
        null_ls = nil
    end
end

return M
