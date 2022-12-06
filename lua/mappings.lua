-- Window navigation (CTRL - Home Keys)
vim.keymap.set('n', "<C-h>", "<C-w>h", { silent = true, desc = "Switch to left window." })
vim.keymap.set('n', "<C-j>", "<C-w>j", { silent = true, desc = "Switch to lower window." })
vim.keymap.set('n', "<C-k>", "<C-w>k", { silent = true, desc = "Switch to upper window." })
vim.keymap.set('n', "<C-l>", "<C-w>l", { silent = true, desc = "Switch to right window." })

-- Window navigation (CTRL - Cursor Keys)
vim.keymap.set('n', "<C-Left>", "<C-w>h", { silent = true, desc = "Switch to left window." })
vim.keymap.set('n', "<C-Down>", "<C-w>j", { silent = true, desc = "Switch to lower window." })
vim.keymap.set('n', "<C-Up>", "<C-w>k", { silent = true, desc = "Switch to upper window." })
vim.keymap.set('n', "<C-Right>", "<C-w>l", { silent = true, desc = "Switch to right window." })

-- Window resizing (CTL - Home Keys)
vim.keymap.set('n', "<C-S-h>", "<C-w>2<", { silent = true, desc = "Decrease window width." })
vim.keymap.set('n', "<C-S-l>", "<C-w>2>", { silent = true, desc = "Increase window width." })
vim.keymap.set('n', "<C-S-k>", "<C-w>2+", { silent = true, desc = "Increase window height." })
vim.keymap.set('n', "<C-S-j>", "<C-w>2-", { silent = true, desc = "Decrease window height." })

-- Window resizing (CTL - Cursor Keys)
vim.keymap.set('n', "<C-S-Left>", "<C-w>2<", { silent = true, desc = "Decrease window width." })
vim.keymap.set('n', "<C-S-Right>", "<C-w>2>", { silent = true, desc = "Increase window width." })
vim.keymap.set('n', "<C-S-Up>", "<C-w>2+", { silent = true, desc = "Increase window height." })
vim.keymap.set('n', "<C-S-Down>", "<C-w>2-", { silent = true, desc = "Decrease window height." })

-- Clear search highlighting
vim.keymap.set('n', "<ESC>", function() vim.cmd("noh") end, { silent = true, desc = "Clear search highlighting" })
