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

-- Save file(s)
vim.keymap.set('n', "<C-s>", ":update<CR>", { silent = true, desc = "Save file" })
vim.keymap.set('n', "<leader><C-s>", ":update<CR>", { silent = true, desc = "Save file" })
vim.keymap.set('n', "<C-S-s>", ":wa<CR>", { silent = true, desc = "Save all files" })
vim.keymap.set('n', "<leader><C-S-s>", ":wa<CR>", { silent = true, desc = "Save all files" })

-- Buffer management
vim.keymap.set('n', "<leader>bl", ":buffers<CR>", { silent = true, desc = "List buffers" })
vim.keymap.set('n', "<leader>bs", "<C-^>", { silent = true, desc = "Toggle current & previous" })
vim.keymap.set('n', "<BS>", "<C-^>", { silent = true, desc = "Toggle current & previous" })
vim.keymap.set('n', "<leader>bb", ":ls<CR>:b<space>", { desc = "Pick buffer" })
vim.keymap.set('n', "<leader>b]", ":bnext<CR>", { silent = true, desc = "Switch next buffer" })
vim.keymap.set('n', "<leader>b[", ":bprev<CR>", { silent = true, desc = "Switch previous buffer" })
vim.keymap.set('n', "<leader>bv", ":ls<CR>:vertical sb<space>", { desc = "Pick & vert. split buffer" })
vim.keymap.set('n', "<leader>bh", ":ls<CR>:horizontal sb<space>", { desc = "Pick & horz. split buffer" })
