local loaded, lsp = pcall(require, "lsp-zero")

if loaded then
    -- Give Mason our global border style
    local globals = require("globals")
    local mason_settings = {
        ui = {
            border = globals.border_style,
        },
    }
    require("mason.settings").set(mason_settings)

    -- Use recommended LSP settings and add nvim's API
    lsp.preset("recommended")
    lsp.nvim_workspace()
    lsp.ensure_installed({ "sumneko_lua", "rust_analyzer", "taplo", "cssls", "html", "tsserver" })

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

    -- Setup nvim-cmp
    local nvim_cmp_config = {
        window = {
            completion = {
                winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                col_offset = -3,
                side_padding = 0,
            },
        },

        sources = {
            { name = "path" },
            { name = "nvim_lsp", keyword_length = 3 },
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
    local navic = require("nvim-navic")
    navic.setup({ highlight = true })
    lsp.on_attach(function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
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

    -- Define icons for diagnostics
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

    -- Setup null-ls
    local null_ls_loaded, null_ls = pcall(require, "null-ls")
    local null_ls_options = lsp.build_options("null-ls", {})
    if null_ls_loaded then
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

    -- Add to which-key categories
    local whickey_loaded, whichkey = pcall(require, "which-key")
    if whickey_loaded then
        whichkey.register({
            l = { name = "LSP" },
        }, { prefix = "<leader>" })
    end
else
    vim.notify("Failed to load plugin: lsp-zero.", vim.log.levels.ERROR)
end
