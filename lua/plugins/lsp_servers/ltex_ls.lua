local M = {}

function M.setup(lsp_config, lsp_capabilities)
    -- By default, `ltex_extra` will try to store dictionaries in the working directory.
    -- I would rather have a global dictionary, so we'll store dictionaries in Neovim's
    -- state storage.
    local dictionary_path = vim.api.nvim_call_function("stdpath", { "state" })

    local ltex_extra_settings = {
        load_langs = { "en-CA", "fr" },
        init_check = true,
        path = "ltex",
        log_level = "none",
        server_start = false,
        server_opts = {
            root_dir = dictionary_path,
        },
    }

    -- Set up the `ltex-ls` LSP server.
    lsp_config.ltex.setup({
        capabilities = lsp_capabilities,

        -- Enable the `ltex-ls` LSP in these file types.
        filetypes = {
            "plaintex",
            "text",
            "markdown",
            "tex",
            "bib",
            "gitcommit",
            "html",
            "lua",
            "rust",
        },

        -- Add `ltex_extras` LSP extension functions when the `ltex` LSP attaches to a buffer.
        on_attach = function()
            require("ltex_extra").setup(ltex_extra_settings)

            -- To-do: Write a `CursorHold` auto command to run a spell check when finished typing rather than on save or open.
        end,

        settings = {
            ltex = {
                -- Enable code comment checking in the following file types.
                -- `ltex-ls` does not use the same file type identifiers as Neovim.
                enabled = {
                    "markdown",
                    "latex",
                    "bibtex",
                    "html",
                    "lua",
                    "rust",
                },
                -- To-do: Change this option to “manual” after implementing the `CursorHold` above.
                checkFrequency = "save",
                language = "en-CA",
                additionalRules = {
                    motherTongue = "en-CA",
                    enablePickyRules = true,
                },
                ["ltex-ls"] = {
                    logLevel = "severe",
                },
                trace = {
                    server = "off",
                },
            },
        },
    })
end

return M
