local M = {}

function M.setup(lsp_zero)
    local null_ls = require("null-ls")

    local null_ls_options = lsp_zero.build_options("null-ls", {})
    local null_ls_config = {
        on_attach = null_ls_options.on_attach,
        sources = {},
    }

    null_ls.setup(null_ls_config)
end

return M
