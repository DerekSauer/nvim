local M = {
    -- Text/code completion engine
    "hrsh7th/nvim-cmp",

    dependencies = {
        -- Snippets engine
        "L3MON4D3/LuaSnip",

        -- Large library of premade snippets
        { "rafamadriz/friendly-snippets", dependencies = "L3MON4D3/LuaSnip" },

        -- Snippet completions
        { "saadparwaiz1/cmp_luasnip", dependencies = "L3MON4D3/LuaSnip" },

        -- File path completions
        "hrsh7th/cmp-path",

        -- Buffer text completion source
        "hrsh7th/cmp-buffer",

        -- Attached LSP as a completion source
        "hrsh7th/cmp-nvim-lsp",

        -- LSP documentSymbol completion source
        "hrsh7th/cmp-nvim-lsp-document-symbol",

        -- LSP function signature completion source
        "hrsh7th/cmp-nvim-lsp-signature-help",

        -- Completions for math operations
        "hrsh7th/cmp-calc",

        -- Completions for emoji
        "hrsh7th/cmp-emoji",

        -- Completeions for nerdfonts
        "chrisgrieser/cmp-nerdfont",

        -- Git as a completion source
        { "petertriho/cmp-git", ft = "gitcommit", config = function() require("cmp_git").setup() end },

        -- Crates.io as a completion source
        { "Saecki/crates.nvim", event = { "Bufread Cargo.toml" },
            dependencies = "nvim-lua/plenary.nvim", config = function() require("crates").setup() end, },

        -- Dap REPL and Dap-UI as completion sources
        { "rcarriga/cmp-dap", ft = { "dap-repl", "dapui_watches", "dapui_hover" } },

        -- Latex symbol completions
        { "amarakon/nvim-cmp-lua-latex-symbols", ft = { "tex", "plaintex" } },

        -- Nvim's command line as a source
        "hrsh7th/cmp-cmdline",

        -- Add LSP symbols to completions
        "onsails/lspkind.nvim",
    },
}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Abbreviated names for sources
local menu_items = {
    nvim_lsp = "[LSP]",
    nvim_lsp_signature_help = "[SIG]",
    nvim_lsp_document_symbol = "[DOC]",
    calc = "[CALC]",
    emoji = "[EMOJI]",
    nerdfont = "[NF]",
    luasnip = "[SNIP]",
    crates = "[CRATE]",
    buffer = "[BUF]",
    path = "[PATH]",
    git = "[GIT]",
    dap = "[DAP]",
    ["lua-latex-symbols"] = "[TEX]",
}

function M.config()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local globals = require("globals")

    -- Set nvim to show a popup menu for completions
    -- without automatically selecting a match
    vim.opt.completeopt = "menu,menuone,noselect"

    -- Default completion selection behavior
    local select_opts = { behavior = cmp.SelectBehavior.Select }

    local config = {
        experimental = {
            -- Display the matching completion inline
            ghost_text = true,
        },

        -- Use LuaSnip as cmp's snippet engine
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },

        -- Open the menu immediately when matches are available
        completion = {
            keyword_length = 1,
            completeopt = "menu,menuone,noselect",
        },

        -- Replace existing text when selecting a completion
        confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },

        -- Add our borders and style the completion and documentation windows
        window = {
            completion = {
                scrolloff = 3,
                border = globals.border_style,
                col_offset = -3,
                side_padding = 0,
                scrollbar = true,
            },

            documentation = {
                border = globals.border_style,
                scrollbar = true,
            },
        },

        sources = cmp.config.sources(
        -- LSP completion group
            {
                { name = "nvim_lsp_signature_help" },
                { name = "nvim_lsp" },
            },

            -- Snippets completion group
            {
                { name = "calc" },
                { name = "emoji" },
                { name = "nerdfont" },
                { name = "luasnip" },
            },

            -- Misc completion group
            {
                { name = "crates" },
                { name = "buffer", option = { keyword_length = 3 } },
                { name = "path" },
            }
        ),

        -- Modify completion menu to show an icon (using 'lspkind') for the completion, followed
        -- by the completion itself and source name.
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                return require("lspkind").cmp_format({ mode = "symbol", menu = menu_items })(entry,
                    vim_item)
            end,
        },

        -- Disable completions when in a comment
        enabled = function()
            local context = require("cmp.config.context")
            if vim.api.nvim_get_mode().mode == "c" then
                return true
            else
                return not context.in_treesitter_capture("comment")
                    and not context.in_syntax_group("Comment")
            end
        end,

        -- Keymaps
        mapping = cmp.mapping.preset.insert({
            -- Accept selected completion
            ["<CR>"] = cmp.mapping.confirm({ select = false }),
            ["<C-y>"] = cmp.mapping.confirm({ select = false }),

            -- Scroll through completion list
            ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
            ["<Down>"] = cmp.mapping.select_next_item(select_opts),
            ["<C-k>"] = cmp.mapping.select_prev_item(select_opts),
            ["<C-j>"] = cmp.mapping.select_next_item(select_opts),

            -- Scroll through documention window
            ["<Right>"] = cmp.mapping.scroll_docs(5),
            ["<Left>"] = cmp.mapping.scroll_docs(-5),
            ["<C-l>"] = cmp.mapping.scroll_docs(5),
            ["<C-h>"] = cmp.mapping.scroll_docs(-5),

            -- Open/Close completion menu
            ["<C-Space>"] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.abort()
                else
                    cmp.complete()
                end
            end),

            -- Jump to next completion in the list, or next snippet placeholder
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            -- Jump to previous completion in the list, or next snippet placeholder
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
    }

    -- Initialize 'nvim-cmp'
    cmp.setup(config)

    -- Enable git completions in git commit messages
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources(
            {
                { name = "git" },
                { name = "nvim_lsp" },
            },
            {
                { name = "buffer" },
            }
        ),
    })

    -- Enable completions in tex files
    cmp.setup.filetype({ "tex", "plaintex" }, {
        sources = cmp.config.sources(
            {
                { name = "nvim_lsp_signature_help" },
                { name = "nvim_lsp" },
            },
            {
                { name = "lua-latex-symbols" },
                { name = "luasnip" },
            },
            {
                { name = "buffer" },
            }
        ),
    })

    -- Enable completions in DAP repl or Dap-UI
    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
            { name = "dap" },
        },
    })

    -- Enable search completions on the command line
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
            {
                { name = "nvim_lsp_document_symbol" },
            },
            {
                { name = "buffer" },
            }
        ),
    })

    -- Enable command completions on the command line
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
            {
                { name = "path" },
            },
            {
                { name = "cmdline" },
            }
        ),
    })

    -- Load snippets from 'friendly-snippets'.
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Create snippet navigation keymaps
    vim.keymap.set({ "s", "n" }, "]n", function() require("luasnip").jump(1) end,
        { desc = "Next snippet placeholder" })
    vim.keymap.set({ "s", "n" }, "[n", function() require("luasnip").jump(-1) end,
        { desc = "Previous snippet placeholder" })
end

return M
