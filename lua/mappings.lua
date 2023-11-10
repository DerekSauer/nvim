local M = {}

function M.setup()
    -- Window navigation (CTRL - Home Keys)
    vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Switch to left window." })
    vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Switch to lower window." })
    vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Switch to upper window." })
    vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Switch to right window." })

    -- Window navigation (CTRL - Cursor Keys)
    vim.keymap.set("n", "<C-Left>", "<C-w>h", { silent = true, desc = "Switch to left window." })
    vim.keymap.set("n", "<C-Down>", "<C-w>j", { silent = true, desc = "Switch to lower window." })
    vim.keymap.set("n", "<C-Up>", "<C-w>k", { silent = true, desc = "Switch to upper window." })
    vim.keymap.set("n", "<C-Right>", "<C-w>l", { silent = true, desc = "Switch to right window." })

    -- Window resizing (CTRL+SHIFT - Home Keys)
    vim.keymap.set("n", "<C-S-h>", "<C-w>2<", { silent = true, desc = "Decrease window width." })
    vim.keymap.set("n", "<C-S-l>", "<C-w>2>", { silent = true, desc = "Increase window width." })
    vim.keymap.set("n", "<C-S-k>", "<C-w>2+", { silent = true, desc = "Increase window height." })
    vim.keymap.set("n", "<C-S-j>", "<C-w>2-", { silent = true, desc = "Decrease window height." })

    -- Window resizing (CTRL+SHIFT - Cursor Keys)
    vim.keymap.set("n", "<C-S-Left>", "<C-w>2<", { silent = true, desc = "Decrease window width." })
    vim.keymap.set("n", "<C-S-Right>", "<C-w>2>", { silent = true, desc = "Increase window width." })
    vim.keymap.set("n", "<C-S-Up>", "<C-w>2+", { silent = true, desc = "Increase window height." })
    vim.keymap.set("n", "<C-S-Down>", "<C-w>2-", { silent = true, desc = "Decrease window height." })

    -- Clear search highlighting
    vim.keymap.set("n", "<ESC>", ":noh<CR>", { silent = true, desc = "Clear search highlighting" })

    -- Save file(s)
    vim.keymap.set("n", "<C-s>", ":update<CR>", { silent = true, desc = "Save file" })
    vim.keymap.set("n", "<leader><C-s>", ":update<CR>", { silent = true, desc = "Save file" })
    vim.keymap.set("n", "<C-S-S>", ":wa<CR>", { silent = true, desc = "Save all files" })
    vim.keymap.set("n", "<leader><C-S-S>", ":wa<CR>", { silent = true, desc = "Save all files" })

    -- Selections
    vim.keymap.set(
        "n",
        "<leader><C-a>",
        ":keepjumps normal! ggVG<CR>",
        { silent = true, desc = "Select all" }
    )
    vim.keymap.set("n", "<C-a>", ":keepjumps normal! ggVG<CR>", { silent = true, desc = "Select all" })

    -- Flip between current and previous buffer.
    vim.keymap.set("n", "<BS>", "<C-^>", { silent = true, desc = "Toggle current & previous" })

    -- Toggle spelling
    vim.keymap.set("n", "<leader>s", ":set spell!<CR>", { silent = true, desc = "Toggle spelling" })
end

return M
