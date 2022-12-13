local neo_tree_ok, neo_tree = pcall(require, "neo-tree")

if neo_tree_ok then
    local globals = require("globals")

    -- Remove depricated legacy commands from neo-tree
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    local config = {
        close_if_last_window = true,
        popup_border_style = globals.border_style,
        use_libuv_file_watcher = true,
        window = {
            position = "left",
            width = 32,
        },
    }

    neo_tree.setup(config)

    vim.keymap.set("n", "<leader>e", function()
        vim.cmd("Neotree toggle")
    end, { silent = true, desc = "Toggle file explorer" })
else
    vim.notify("Failed to load plugin: neo-tree.", vim.log.levels.ERROR)
    neo_tree = nil
end
