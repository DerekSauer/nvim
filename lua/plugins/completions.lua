local M = {
    -- Text/code completion engine
    "hrsh7th/nvim-cmp",
    dependencies = {
        -- Snippets engine
        "L3MON4D3/LuaSnip",

        -- Large library of premade snippets
        { "rafamadriz/friendly-snippets", dependencies = "L3MON4D3/LuaSnip" },

        -- Snippet completions
        { "saadparwaiz1/cmp_luasnip",     dependencies = "L3MON4D3/LuaSnip" },

        -- File path completions
        "hrsh7th/cmp-path",

        -- Buffer text completion source
        "hrsh7th/cmp-buffer",

        -- Attached LSP as a completion source
        "hrsh7th/cmp-nvim-lsp",

        -- Nvim's command line as a source
        "hrsh7th/cmp-cmdline",

        -- Crates.io as a completion source
        {
            "Saecki/crates.nvim",
            event = { "Bufread Cargo.toml" },
            dependencies = "nvim-lua/plenary.nvim",
            config = function() require("crates").setup() end,
        },

        -- Dap REPL and Dap-UI as completion sources
        { "rcarriga/cmp-dap", ft = { "dap-repl", "dapui_watches", "dapui_hover" } },
    },
}

-- Abbreviated names for sources
local menu_items = {
    nvim_lsp = "[LSP]",
    luasnip = "[SNIP]",
    crates = "[CRATE]",
    buffer = "[BUF]",
    path = "[PATH]",
    dap = "[DAP]",
}

-- Icons for the 'kind' of completion menu entry
local kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = "",
}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.config()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local globals = require("globals")

    -- Default completion selection behavior
    local select_opts = { behavior = cmp.SelectBehavior.Select }

    local config = {
        -- Display the matching completion inline
        experimental = {
            ghost_text = { enabled = true },
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
                { name = "nvim_lsp" },
            },

            -- Snippets completion group
            {
                { name = "luasnip" },
            },

            -- Misc completion group
            {
                { name = "crates" },
                { name = "path" },
                { name = "buffer", option = { keyword_length = 3 } },
            }
        ),
        -- Modify completion menu to show an icon for the completion, followed
        -- by the completion item itself and source name.
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                vim_item.kind = kind_icons[vim_item.kind] or "??"
                vim_item.menu = menu_items[entry.source.name] or "??"

                -- Suppress duplicate entries
                vim_item.dup = ({ nvim_lsp = 0 })[entry.source.name] or 0

                return vim_item
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
                { name = "cmdline" },
            }
        ),
    })

    -- Load snippets from 'friendly-snippets'.
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Load my own snippets
    require("luasnip.loaders.from_lua").lazy_load({ paths = "./snippets" })

    -- Create snippet navigation keymaps
    vim.keymap.set({ "s", "n" }, "]n", function() require("luasnip").jump(1) end,
        { desc = "Next snippet placeholder" })
    vim.keymap.set({ "s", "n" }, "[n", function() require("luasnip").jump(-1) end,
        { desc = "Previous snippet placeholder" })
end

return M
