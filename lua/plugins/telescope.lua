local M = {
    -- Telescope fuzzy finder
    -- https://github.com/nvim-telescope/telescope.nvim
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-frecency.nvim",
        "nvim-telescope/telescope-project.nvim",
        "nvim-telescope/telescope-dap.nvim",
        "nvim-tree/nvim-web-devicons",
        "kkharji/sqlite.lua",
    },
}

function M.config()
    local telescope = require("telescope")

    local config = {
        defaults = {
            layout_strategy = "flex",
            border = true,
            borderchars = require("globals").telescope_border_style,
        },

        extensions = {},
    }

    telescope.setup(config)
    telescope.load_extension("project")
    telescope.load_extension("dap")

    -- Having trouble making the sqlite3 dev libs available for this extension on windows
    if vim.fn.has("win32") == 0 then telescope.load_extension("frecency") end

    -- Key mappings
    vim.keymap.set(
        "n",
        "<leader>ff",
        function() require("telescope.builtin").find_files() end,
        { silent = true, desc = "Find files" }
    )
    vim.keymap.set(
        "n",
        "<leader>fs",
        function() require("telescope.builtin").grep_string() end,
        { silent = true, desc = "String grep" }
    )
    vim.keymap.set(
        "n",
        "<leader>fg",
        function() require("telescope.builtin").live_grep() end,
        { silent = true, desc = "Live grep" }
    )
    vim.keymap.set(
        "n",
        "<leader>fb",
        function() require("telescope.builtin").buffers() end,
        { silent = true, desc = "Buffers" }
    )
    vim.keymap.set(
        "n",
        "<leader>fm",
        function() require("telescope.builtin").man_pages() end,
        { silent = true, desc = "Man pages" }
    )
    vim.keymap.set(
        "n",
        "<leader>fq",
        function() require("telescope.builtin").quickfix() end,
        { silent = true, desc = "Quickfix list" }
    )
    vim.keymap.set(
        "n",
        "<leader>fl",
        function() require("telescope.builtin").loclist() end,
        { silent = true, desc = "Location list" }
    )
    vim.keymap.set(
        "n",
        "<leader>f/",
        function() require("telescope.builtin").keymaps() end,
        { silent = true, desc = "Keymap help" }
    )

    vim.keymap.set(
        "n",
        "<leader>fr",
        function() require("telescope").extensions.frecency.frecency() end,
        { silent = true, desc = "Recent files" }
    )
    vim.keymap.set(
        "n",
        "<leader>fp",
        function() require("telescope").extensions.project.project() end,
        { silent = true, desc = "Projects" }
    )

    -- Add to which-key categories
    require("which-key").register({
        f = { name = "Finder" },
    }, { prefix = "<leader>" })
end

return M
