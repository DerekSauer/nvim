-- Map leader
vim.g.mapleader = ","

-- Neovim Options
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
    tab = "→ ",
    nbsp = "␣",
    trail = "•",
    extends = "⟩",
    precedes = "⟨",
}
vim.opt.fillchars:append("eob: ")
vim.opt.whichwrap:append("h,l,<,>,[,]")
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.winbar = " "
vim.opt.linebreak = true

-- Use the new zero command line height when available
if vim.fn.has("nvim-0.8") == 1 then vim.opt.cmdheight = 0 end

-- Use ripgrep if available
if vim.fn.executable("rg") == 1 then
    vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
    vim.opt.grepformat = "%f:%l:%c:%m"
end

-- On Windows use a work around for poor clipboard performance
-- Needs win32yank installed (scoop install win32yank)
-- Credit, Yioneko @ https://github.com/yioneko
-- https://github.com/neovim/neovim/issues/21739#issuecomment-1399405391
if vim.fn.has("win32") or vim.fn.has("wsl") then
    require("win_clipboard").setup()
else
    vim.opt.clipboard = "unnamedplus"
end

-- On Windows use Powershell for terminal commands
if vim.fn.has("win32") == 1 then
    vim.opt.shell = "pwsh.exe"
    vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
    vim.opt.shellxquote = ""
    vim.opt.shellquote = ""
    vim.opt.shellredir = "2>&1 | Out-File -Encoding UTF8 %s"
    vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s"
end

-- Disable remote plugin providers we will probably never use
vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Set LSP logging level to errors only
local lsp_log = require("vim.lsp.log")
lsp_log.set_level(lsp_log.levels.ERROR)

-- Setup my own auto commands
require("functions").setup_autocmds()

-- Setup the diagnostics interface
require("diagnostics").setup()

-- Bootstrap Lazy.nvim if it is not installed
require("bootstrap").setup()

-- Setup Lazy.nvim to manage my plugins
local lazy_ok, lazy = pcall(require, "lazy")
if lazy_ok then
    -- Windows can't seem to handle running dozens of Lazy.nvim tasks at a time
    -- Limit it on Windows platform
    local lazy_task_count = vim.fn.has("win32") == 1 and 10 or nil

    local config = {
        change_detection = {
            enabled = false,
            notify = false,
        },
        checker = {
            enabled = true,
            notify = false,
            frequency = 14400,
        },
        concurrency = lazy_task_count,
        install = {
            colorscheme = { "kanagawa" },
        },
        performance = {
            cache = {
                enabled = true,
                disable_events = { "VimEnter", "BufReadPre" },
            },
            rtp = {
                disabled_plugins = {
                    "gzip",
                    "matchit",
                    "matchparen",
                    "netrwPlugin",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
        ui = {
            border = require("globals").border_style,
        },
    }

    lazy.setup("plugins", config)
else
    vim.notify(
        string.format("Failed to load `Lazy.nvim` plugin manager.\nError message: %s", lazy),
        vim.log.levels.ERROR
    )
    lazy = nil
end

-- Load key mappings not handled by Which-key
require("mappings")
