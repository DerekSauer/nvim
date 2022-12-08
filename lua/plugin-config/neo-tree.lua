local loaded, neo_tree = pcall(require, "neo-tree")

if not loaded then
    vim.notify("Failed to load plugin: neo-tree", vim.log.levels.ERROR)
    neo_tree = nil
end

if neo_tree then
    local globals = require("globals")

    -- Remove depricated legacy commands from neo-tree
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    local config = {
        close_if_last_window = true,
        popup_border_style = globals.border_style,
        use_libuv_file_watcher = true,
        source_selector = {
            winbar = true
        },
        window = {
            position = "left",
            width = 32
        }
    }

    neo_tree.setup(config)

    vim.keymap.set('n', "<leader>ee", function() vim.cmd("Neotree focus filesystem left") end, { silent = true, desc = "Open file explorer." })
    vim.keymap.set('n', "<leader>ec", function() vim.cmd("Neotree close filesystem left") end, { silent = true, desc = "Close file explorer." })
    vim.keymap.set('n', "<leader>eb", function() vim.cmd("Neotree focus buffers left") end, { silent = true, desc = "Show buffers in file explorer." })
    vim.keymap.set('n', "<leader>eg", function() vim.cmd("Neotree focus git_status left") end, { silent = true, desc = "Show git status in file explorer." })
    vim.keymap.set('n', "<leader>er", function() vim.cmd("Neotree reveal left") end, { silent = true, desc = "Focus on current file in file explorer." })

    -- Add keymap group for neo-tree to which-key
    local loaded, whichkey = pcall(require, "which-key")
    if loaded then
        whichkey.register({ e = { name = "File Explorer" } }, { prefix = "<leader>" })
    end
end
