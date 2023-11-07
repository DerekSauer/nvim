local M = {
    -- Code & text completion engine.
    "hrsh7th/nvim-cmp",

    dependencies = {
        -- Snippet completion source.
        "saadparwaiz1/cmp_luasnip",

        -- File path completions.
        "hrsh7th/cmp-path",

        -- Buffer text completion source.
        "hrsh7th/cmp-buffer",

        -- Attached LSP as a completion source.
        "hrsh7th/cmp-nvim-lsp",

        -- Nvim's command line as a source.
        "hrsh7th/cmp-cmdline",

        -- Crates.io as a completion source.
        {
            "Saecki/crates.nvim",
            event = { "Bufread Cargo.toml" },
            dependencies = "nvim-lua/plenary.nvim",
            config = function() require("crates").setup() end,
        },

        -- Dap REPL and Dap-UI as completion sources>
        { "rcarriga/cmp-dap", ft = { "dap-repl", "dapui_watches", "dapui_hover" } },

        -- Comparator for words starting with an underscore.
        "lukas-reineke/cmp-under-comparator",
    },

    -- Enable completions when entering insert mode in a buffer or the command line.
    event = { "InsertEnter", "CmdlineEnter" },
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
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = " ",
    Variable = "",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    EnumMember = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = " ",
    Misc = " ",
    TabNine = "󰚩 ",
    Copilot = " ",
    Unknown = " ",
}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.config()
    local cmp = require("cmp")
    local types = require("cmp.types")
    local luasnip = require("luasnip")
    local globals = require("globals")

    -- Completion sorting function to place LSP snippets (Not Luasnip snippets)
    -- At the end of the list. Some LSPs like Rust-Analyzer return many LSP
    -- snippets with every operation; I'd rather see the type's members and
    -- functions first.
    local lsp_snippet_sort = function(entry1, entry2)
        local kind1 = entry1:get_kind()
        local kind2 = entry2:get_kind()

        if kind1 ~= kind2 then
            if kind1 == types.lsp.CompletionItemKind.Snippet then
                return false
            end
            if kind2 == types.lsp.CompletionItemKind.Snippet then
                return true
            end
        end

        return false
    end

    -- Select the first valid completion.
    local select_opts = { behavior = cmp.SelectBehavior.Select }

    local config = {
        -- Display the matching completions inline.
        experimental = {
            ghost_text = true,
        },

        -- Use LuaSnip as cmp's snippet engine.
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },

        -- Open the completion menu after matching at least two characters.
        completion = {
            keyword_length = 2,
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

        -- Configure the ordering of completion sources.
        sources = cmp.config.sources({
            { name = "nvim_lsp", option = { keyword_length = 2 } },
            { name = "luasnip" },
            { name = "crates" },
            { name = "path" },
            { name = "buffer",   option = { keyword_length = 4 }, max_item_count = 5 },
        }),

        -- Sorting priorities for completions.
        sorting = {
            priority_weight = 1.0,
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                cmp.config.compare.recently_used,
                require("cmp-under-comparator").under,
                lsp_snippet_sort,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },

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

        -- Disable completions when in a comment block.
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
                elseif luasnip.expand_or_locally_jumpable() then
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
                elseif luasnip.locally_jumpable(-1) then
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
end

return M
