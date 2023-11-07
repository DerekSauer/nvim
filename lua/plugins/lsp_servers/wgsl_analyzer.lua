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

        settings = {
            ["wgsl-analyzer"] = {
                diagnostics = {
                    typeErrors = true,
                    nagaParsing = true,
                    nagaValidation = true,
                    nagaVersion = "main",
                },
                inlayHints = {
                    enabled = true,
                    typeHints = true,
                    parameterHints = true,
                    structLayoutHints = true,
                    typeVerbosity = "compact",
                },
            },
        },
    })
end

return M
