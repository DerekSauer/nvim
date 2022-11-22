-- Disable remote plugin providers we will probably never use
vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider  = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_node_provider    = 0

-- Disable some in built plugins completely
vim.g.loaded_netrw            = 1
vim.g.loaded_netrwPlugin      = 1
vim.g.loaded_matchparen       = 1
vim.g.loaded_matchit          = 1
vim.g.loaded_2html_plugin     = 1
vim.g.loaded_getscriptPlugin  = 1
vim.g.loaded_gzip             = 1
vim.g.loaded_logipat          = 1
vim.g.loaded_rrhelper         = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin        = 1
vim.g.loaded_vimballPlugin    = 1
vim.g.loaded_zipPlugin        = 1

-- Map leader
vim.g.mapleader      = ","
vim.g.maplocalleader = " "

-- Set LSP logging level to errors only
lsp_log = require("vim.lsp.log")
lsp_log.set_level(lsp_log.levels.ERROR)
