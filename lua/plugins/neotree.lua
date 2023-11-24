local M = {
    -- Neo-tree file drawer.
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
}

function M.config()
    require("neo-tree").setup({
        -- When Neo-tree is the only remaining window, close Neovim.
        close_if_last_window = true,

        -- Use the global border style and position the file browser to the left of the screen.
        popup_border_style = require("globals").border_style,
        window = {
            position = "left",
            width = 32,
        },

        -- Enable Git status icons.
        enable_git_status = true,

        -- Enable diagnostics icons.
        enable_diagnostics = true,

        -- Configuration options common to all Neo-tree sub-systems.
        default_component_configs = {
            -- Directory icons.
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "󰜌",
            },

            -- Git status icons.
            git_status = {
                symbols = {
                    -- Added and Modified symbols are not needed.
                    -- The color of the file name provides the same information.
                    added = "",
                    modified = "",
                    deleted = "",
                    renamed = "󰁕",
                    untracked = "",
                    ignored = "",
                    unstaged = "󰄱",
                    staged = "",
                    conflict = "",
                },
            },

            -- Disable file information columns that we'll never see.
            file_size = {
                enabled = false,
            },
            type = {
                enabled = false,
            },
            last_modified = {
                enabled = false,
            },
            created = {
                enabled = false,
            },
            symlink_target = {
                enabled = false,
            },
        },

        filesystem = {
            -- Disable file watcher on Windows.
            -- Poor performance and errors when deleting or moving a file.
            use_libuv_file_watcher = vim.fn.has("win32") == 0 and true or false,
        },
    })

    -- Key map to open and close the file browser (LEADER+e).
    vim.keymap.set("n", "<leader>e", function()
        vim.cmd("Neotree toggle")
    end, { silent = true, desc = "Toggle file explorer" })
end

return M
