local loaded, telescope = pcall(require, "telescope")

if loaded then
    local globals = require("globals")

    local config = {
        defaults = {
            layout_strategy = 'flex',
            border = true,
            borderchars = { "═", "│", "═", "│", "╒", "╕", "╛", "╘" },
        },

        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown()
            }
        }
    }

    telescope.setup(config)
    telescope.load_extension("frecency")
    telescope.load_extension("project")
    telescope.load_extension("ui-select")

    local dap_loaded, _ = pcall(require, "dap")
    if dap_loaded then 
        telescope.load_extension("dap")
    end

    -- Key mappings
    vim.keymap.set('n', "<leader>ff", function() require("telescope.builtin").find_files() end, { silent = true, desc = "Find files" })
    vim.keymap.set('n', "<leader>fs", function() require("telescope.builtin").grep_string() end, { silent = true, desc = "String grep" })
    vim.keymap.set('n', "<leader>fg", function() require("telescope.builtin").live_grep() end, { silent = true, desc = "Live grep" })
    vim.keymap.set('n', "<leader>fb", function() require("telescope.builtin").buffers() end, { silent = true, desc = "Buffers" })
    vim.keymap.set('n', "<leader>fm", function() require("telescope.builtin").man_pages() end, { silent = true, desc = "Man pages" })
    vim.keymap.set('n', "<leader>fq", function() require("telescope.builtin").quickfix() end, { silent = true, desc = "Quickfix list" })
    vim.keymap.set('n', "<leader>fl", function() require("telescope.builtin").loclist() end, { silent = true, desc = "Location list" })
    vim.keymap.set('n', "<leader>f/", function() require("telescope.builtin").keymaps() end, { silent = true, desc = "Keymap help" })

    vim.keymap.set('n', "<leader>fr", function() require("telescope").extensions.frecency.frecency() end, { silent = true, desc = "Recent files" })
    vim.keymap.set('n', "<leader>fp", function() require("telescope").extensions.project.project() end, { silent = true, desc = "Projects" })

    -- Add to which-key categories
    local loaded, whichkey = pcall(require, "which-key")
    if loaded then 
        whichkey.register({
            f = { name = "Finder" },
        }, { prefix = "<leader>" })
    end
else
    vim.notify("Failed to load plugin: telescope.", vim.log.levels.ERROR)
    telescope = nil
end
