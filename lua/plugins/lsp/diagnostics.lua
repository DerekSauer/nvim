local M = {}

function M.setup()
    local globals = require("globals")

    vim.diagnostic.config({
        underline = true,
        virtual_text = false,
        virtual_lines = true,
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

    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = globals.border_style })

    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = globals.border_style })

    -- Define icons for diagnostics
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

    -- Setup LSP diagnostics renderer
    require("lsp_lines").setup()
    vim.keymap.set(
        "n",
        "<leader>D",
        require("lsp_lines").toggle,
        { silent = true, desc = "Toggle diagnostics" }
    )

    -- Add key maps for jumping to diagnostics
    vim.keymap.set(
        "n",
        "]d",
        function() vim.diagnostic.goto_next() end,
        { silent = true, desc = "Jump to next diagnostic" }
    )
    vim.keymap.set(
        "n",
        "[d",
        function() vim.diagnostic.goto_prev() end,
        { silent = true, desc = "Jump to previous diagnostic" }
    )
end

return M
