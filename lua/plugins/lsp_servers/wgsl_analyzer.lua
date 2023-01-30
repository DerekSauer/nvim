local M = {}

function M.setup(lsp_config, lsp_capabilities)
    -- Autocommand to assign the 'wgsl' filetype to wsgl files
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        group = require("globals").user_au_group,
        pattern = { "*.wgsl" },
        command = "set filetype=wgsl",
    })

    lsp_config.wgsl_analyzer.setup({
        capabilities = lsp_capabilities,
        filetypes = { "wgsl" },

        settings = {},
    })
end

return M
