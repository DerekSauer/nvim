local lsp_ok, lsp = pcall(require, "lsp-zero")

if lsp_ok then
    local globals = require("globals")

    -- Customize Mason
    local mason_ok, mason = pcall(require, "mason.settings")
    if mason_ok then
        local mason_settings = {
            ui = {
                border = globals.border_style,
            },
        }
        mason.set(mason_settings)
    end

    -- Use recommended LSP settings and add nvim's API
    lsp.preset("recommended")
    lsp.nvim_workspace()

    -- Setup lua-language-server
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    lsp.configure("sumneko_lua", {
        settings = {
            Lua = {
                format = {
                    enable = false,
                },
                runtime = {
                    version = "LuaJIT",
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })

    -- Setup rust-analyzer
    lsp.configure("rust_analyzer", {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
                lens = {
                    enable = false,
                },
            },
        },
    })

    -- Setup nvim-cmp
    local nvim_cmp_config = {
        completion = {
            scrolloff = 3,
            border = globals.border_style,
        },

        documentation = {
            border = globals.border_style,
        },

        sources = {
            { name = "path" },
            { name = "nvim_lsp", keyword_length = 3 },
            { name = "nvim_lsp_signature_help" },
            { name = "nvim_lua" },
            { name = "buffer", keyword_length = 3 },
            { name = "luasnip", keyword_length = 2 },
        },

        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                kind.kind = " " .. strings[1] .. " "
                kind.menu = "    (" .. strings[2] .. ")"

                return kind
            end,
        },
    }
    lsp.setup_nvim_cmp(nvim_cmp_config)

    -- Setup navic
    local navic_ok, navic = pcall(require, "nvim-navic")
    if navic_ok then
        navic.setup({ depth_limit = 6, highlight = true })
    end

    -- Setup lsp-format
    local lsp_format_ok, lsp_format = pcall(require, "lsp-format")
    if lsp_format_ok then
        lsp_format.setup()
    end

    -- Attach additional LSP unfunctionality
    lsp.on_attach(function(client, bufnr)
        -- Feed LSP data to navic if the LSP has a symbol provider
        if client.server_capabilities.documentSymbolProvider then
            if navic_ok then
                -- TODO: Make this more intelligent
                navic.attach(client, bufnr)
            end
        end

        -- Add auto formatting to LSPs that support formatting
        if client.supports_method("textDocument/formatting") then
            lsp_format.on_attach(client)
        end
    end)

    lsp.setup()

    -- Configure nvim's diagnostics interface
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

    -- Setup null-ls
    local null_ls_ok, null_ls = pcall(require, "null-ls")
    local null_ls_options = lsp.build_options("null-ls", {})
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

    -- Lsp key mappings
    vim.keymap.set("n", "<leader>lk", function()
        vim.lsp.buf.hover()
    end, { silent = true, desc = "Symbol hover info" })
    vim.keymap.set("n", "<leader>ld", function()
        vim.lsp.buf.definition()
    end, { silent = true, desc = "Jump symbol definition" })
    vim.keymap.set("n", "<leader>lD", function()
        vim.lsp.buf.declaration()
    end, { silent = true, desc = "Jump symbol declaration" })
    vim.keymap.set("n", "<leader>li", function()
        vim.lsp.buf.implementation()
    end, { silent = true, desc = "List symbol implementations" })
    vim.keymap.set("n", "<leader>lt", function()
        vim.lsp.buf.type_definition()
    end, { silent = true, desc = "Jump type definition" })
    vim.keymap.set("v", "<leader>lf", function()
        vim.lsp.buf.range_formatting()
    end, { silent = true, desc = "Format selection" })
    vim.keymap.set("n", "<leader>lr", function()
        vim.lsp.buf.references()
    end, { silent = true, desc = "List symbol references" })
    vim.keymap.set("n", "<leader>l<F2>", function()
        vim.lsp.buf.rename()
    end, { silent = true, desc = "Rename symbol" })
    vim.keymap.set("n", "<leader>l<F4>", function()
        vim.lsp.buf.code_action()
    end, { silent = true, desc = "Code actions" })
    vim.keymap.set("n", "<leader>lp", function()
        require("telescope.builtin").diagnostics()
    end, { silent = true, desc = "List diagnostics" })
    vim.keymap.set("n", "<leader>lf", ":LspZeroFormat<CR>", { silent = true, desc = "Format file" })
    vim.keymap.set("i", "<C-k>", function()
        vim.lsp.buf.signature_help()
    end, { silent = true, desc = "Signature help" })

    vim.keymap.set({ "s", "n" }, "]s", function()
        require("luasnip").jump(1)
    end, { silent = true, desc = "Next snippet placeholder" })

    vim.keymap.set({ "s", "n" }, "[s", function()
        require("luasnip").jump(-1)
    end, { silent = true, desc = "Next snippet placeholder" })

    vim.keymap.set({ "s", "n" }, "<C-]>", function()
        require("luasnip").jump(1)
    end, { silent = true, desc = "Next snippet placeholder" })

    vim.keymap.set({ "s", "n" }, "<C-[>", function()
        require("luasnip").jump(-1)
    end, { silent = true, desc = "Next snippet placeholder" })

    -- Add to which-key categories
    local whickey_loaded, whichkey = pcall(require, "which-key")
    if whickey_loaded then
        whichkey.register({
            l = { name = "LSP" },
        }, { prefix = "<leader>" })
    end
else
    vim.notify("Failed to load plugin: lsp-zero.", vim.log.levels.ERROR)
    lsp = nil
end
