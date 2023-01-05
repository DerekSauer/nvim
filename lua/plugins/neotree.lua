local M = {
    -- Neo-tree file drawer
    -- https://github.com/nvim-neo-tree/neo-tree.nvim
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
}

function M.config()
    local neo_tree = require("neo-tree")

    -- Remove depricated legacy commands from neo-tree
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    local config = {
        close_if_last_window = true,
        popup_border_style = require("globals").border_style,
        use_libuv_file_watcher = true,
        window = {
            position = "left",
            width = 32,
        },
    }

    neo_tree.setup(config)

    vim.keymap.set(
        "n",
        "<leader>e",
        function() vim.cmd("Neotree toggle") end,
        { silent = true, desc = "Toggle file explorer" }
    )
end

return M
