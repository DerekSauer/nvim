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
    local neo_tree = require("neo-tree")

    local config = {
        close_if_last_window = true,

        popup_border_style = require("globals").border_style,
        window = {
            position = "left",
            width = 32,
        },

        default_component_configs = {
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "󰜌",
            },
            git_status = {
                symbols = {
                    added = "",
                    modified = "",
                    deleted = "",
                    renamed = "󰁕",
                    untracked = "",
                    ignored = "",
                    unstaged = "󰄱",
                    staged = "",
                    conflict = "",
                },
            },
        },

        document_symbols = {
            kinds = {
                File = { icon = "󰈙", hl = "Tag" },
                Namespace = { icon = "󰌗", hl = "Include" },
                Package = { icon = "󰏖", hl = "Label" },
                Class = { icon = "󰌗", hl = "Include" },
                Property = { icon = "󰆧", hl = "@property" },
                Enum = { icon = "󰒻", hl = "@number" },
                Function = { icon = "󰊕", hl = "Function" },
                String = { icon = "󰀬", hl = "String" },
                Number = { icon = "󰎠", hl = "Number" },
                Array = { icon = "󰅪", hl = "Type" },
                Object = { icon = "󰅩", hl = "Type" },
                Key = { icon = "󰌋", hl = "" },
                Struct = { icon = "󰌗", hl = "Type" },
                Operator = { icon = "󰆕", hl = "Operator" },
                TypeParameter = { icon = "󰊄", hl = "Type" },
                StaticMethod = { icon = "󰠄 ", hl = "Function" },
            },
        },
        -- Disable file system watching on Windows. Really bad perf.
        filesystem = {
            use_libuv_file_watcher = vim.fn.has("win32") == 1 and false or true,
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
