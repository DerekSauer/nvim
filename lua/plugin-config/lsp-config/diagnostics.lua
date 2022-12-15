local M = {}

function M.setup()
    local globals = require("globals")

    vim.diagnostic.config({
        underline = true,
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            border = globals.border_style,
            format = function(diagnostic)
                return string.format(
                    "%s (%s) [%s]",
                    diagnostic.message,
                    diagnostic.source,
                    diagnostic.code or diagnostic.user_data.lsp.code
                )
            end,
        },
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = globals.border_style })

    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = globals.border_style })

    -- Define icons for diagnostics
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

    -- Create autocommand to show diagnostics window when hovering over an issue
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
        pattern = { "*" },
        callback = function()
            vim.diagnostic.open_float({ scope = "line", severity_sort = true, source = "if_many" })
        end,
    })
end

return M
