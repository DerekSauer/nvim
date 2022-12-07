-- https://github.com/VonHeikemen/nvim-starter

-- Map leader
vim.g.mapleader = ","

-- Neovim Options
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.updatetime = 300
vim.opt.timeoutlen = 300
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.showbreak = "↪ "
vim.opt.list = true
vim.opt.listchars = {
  tab      = "→ ",
  nbsp     = "␣",
  trail    = "•",
  extends  = "⟩",
  precedes = "⟨",
}
vim.opt.fillchars:append("eob: ")
vim.opt.whichwrap:append("h,l,<,>,[,]")
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.pumblend = 15
vim.opt.winblend = 15

-- Use ripgrep if available
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- On Windows use Powershell for terminal commands
if vim.fn.has "win32" == 1 then
  vim.opt.shell = "pwsh.exe"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
  vim.opt.shellxquote = ""
  vim.opt.shellquote = ""
  vim.opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s"
  vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s"
end

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

-- Set LSP logging level to errors only
lsp_log = require("vim.lsp.log")
lsp_log.set_level(lsp_log.levels.ERROR)

-- Install Packer if needed
PACKER_BOOTSTRAP = require("bootstrap").ensure_packer()

require("plugins")
require("globals")
require("mappings")
