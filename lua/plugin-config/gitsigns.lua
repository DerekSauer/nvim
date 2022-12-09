local loaded, gitsigns = pcall(require, "gitsigns")

if loaded then
    local globals = require("globals")

    local config = {
        signs = {
            add          = { hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
            change       = { hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
            delete       = { hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
            topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
            changedelete = { hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
            untracked    = { hl = 'GitSignsAdd'   , text = '┆', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
        },

        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`

        watch_gitdir = {
            interval = 1000,
            follow_files = true
        },

        attach_to_untracked = true,

        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 10000, -- Disable if file is longer than this (in lines)

        preview_config = {
            border = globals.border_style,
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
        },

        yadm = {
            enable = false
        },

        -- Setup key mappings when attached to a buffer tracked by Git
        on_attach = function(bufnr)
            local function map(mode, l, r, opts)
                local opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Jump to next hunk with ]g
            map('n', ']g', function()
                if vim.wo.diff then 
                    return ']g' 
                end

                vim.schedule(function() gitsigns.next_hunk() end)

                return '<Ignore>'
            end, {expr=true, desc = "Jump to next hunk"})

            -- Jump to previous hunk with [g
            map('n', '[g', function()
                if vim.wo.diff then 
                    return '[g'
                end

                vim.schedule(function() gitsigns.prev_hunk() end)

                return '<Ignore>'
            end, {expr=truei, desc = "Jump to previous hunk"})

            map({'n', 'v'}, '<leader>gs', ':Gitsigns stage_hunk<CR>', { desc = "Stage hunk"})
            map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>', { desc = "Reset hunk"})
            map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = "Undo stage hunk"})
            map('n', '<leader>gp', gitsigns.preview_hunk, { desc = "Preview hunk" })
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select hunk"})
            map('n', '<leader>gS', gitsigns.stage_buffer, { desc = "Stage buffer" })
            map('n', '<leader>gR', gitsigns.reset_buffer, { desc = "Reset stage buffer" })
            map('n', '<leader>gb', function() gitsigns.blame_line{full=true} end, { desc = "Blame this line" })
            map('n', '<leader>gd', gitsigns.diffthis, { desc = "Show diff" })
            map('n', '<leader>gD', function() gitsigns.diffthis('~') end, { desc = "Diff last commit" })

            map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = "Toggle line blames" })
            map('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = "Toggle deleted indicators" })
            map('n', '<leader>gtn', gitsigns.toggle_numhl, { desc = "Toggle number highlighting" })
            map('n', '<leader>gtl', gitsigns.toggle_linehl, { desc = "Toggle line highlighting" })
            map('n', '<leader>gts', gitsigns.toggle_signs, { desc = "Toggle sign highlighting" })

            -- Add which-key categories
            local loaded, whichkey = pcall(require, "which-key")
            if loaded then 
                whichkey.register({
                    g = { name = "Git",
                             t = { name = "Toggle" }
                        }
                    }, { prefix = "<leader>" })
            end
        end
    }

    gitsigns.setup(config)
else
    vim.notify("Failed to load plugin: gitsigns.", vim.log.levels.ERROR);
    gitsigns = nil
end
