local M = {}

function M.setup()
    -- Map leader
    vim.g.mapleader = ","

    -- Use operating system's clipboard.
    vim.opt.clipboard = "unnamedplus"

    -- Use UTF-8 for internal buffers.
    vim.opt.encoding = "utf-8"

    -- Interpret and save files as UTF-8.
    vim.opt.fileencoding = "utf-8"

    -- Time to wait with no text entry before triggering the `CursorHold` event.
    vim.opt.updatetime = 300

    -- Time to wait for key mapped sequences to complete.
    vim.opt.timeoutlen = 250

    -- Suppress showing the mode, our status line already does it.
    vim.opt.showmode = false

    -- Highlight search results.
    vim.opt.hlsearch = true

    -- Ignore character case when searching.
    vim.opt.ignorecase = true

    -- Override `ignorecase` if the search term contains an upper case character.
    vim.opt.smartcase = true

    -- Convert <Tab> into spaces.
    vim.opt.expandtab = true

    -- <Tab> counts as four spaces.
    vim.opt.tabstop = 4

    -- Behave as though <Tab> are still <Tab> instead of spaces.
    vim.opt.softtabstop = 4

    -- Maintain current indent level when starting a new line.
    vim.opt.autoindent = true

    -- Indent when starting a code block.
    vim.opt.smartindent = true

    -- Indent by the same number of spaces as `tabstop`.`
    vim.opt.shiftwidth = 0

    -- Round indents to nearest `shiftwidth`.
    vim.opt.shiftround = true

    -- Do not soft wrap lines that are longer than the window width.
    vim.opt.wrap = false

    -- Indent soft wrapped lines.
    vim.opt.breakindent = true

    -- Character to indicate soft wrapped lines.
    vim.opt.showbreak = "↪ "

    -- Do not cut off words when soft wrapping lines.
    vim.opt.linebreak = true

    -- Additional keys allowed to move to next line when at the start/end of a line.
    vim.opt.whichwrap:append("h,l,<,>,[,]")

    -- Start scrolling eight lines before the end of the window.
    vim.opt.scrolloff = 8

    -- Start scrolling eight columns before the end of the window.
    vim.opt.sidescrolloff = 8

    -- Highlight the line where the cursor is currently located.
    vim.opt.cursorline = true

    -- Show line numbers in the gutter.
    vim.opt.number = true

    -- Minimum number of columns for numbers in the gutter.
    vim.opt.numberwidth = 3

    -- Show relative line numbers.
    vim.opt.relativenumber = true

    -- Enable icons in the gutter.
    vim.opt.signcolumn = "yes"

    -- Enable global status line instead of a status line per window.
    vim.opt.laststatus = 3

    -- Use 24-bit colors in the built in terminal.
    vim.opt.termguicolors = true

    -- Place new horizontal splits below the current window.
    vim.opt.splitbelow = true

    -- Place new vertical splits to the right of the current window.
    vim.opt.splitright = true

    -- Show special characters.
    vim.opt.list = true

    -- Define how special characters are displayed.
    vim.opt.listchars = {
        tab = "→ ",
        nbsp = "␣",
        trail = "•",
        extends = "⟩",
        precedes = "⟨",
    }

    -- Disable the `~` end of buffer indicator.
    vim.opt.fillchars:append("eob: ")

    -- Limit the height of popup menus.
    vim.opt.pumheight = 20

    -- Do not display the command line unless entering a command.
    vim.opt.cmdheight = 0

    -- Suppress displaying visual selection ranges.
    vim.opt.showcmd = false

    -- Enable mouse support.
    vim.opt.mouse = "a"

    -- Disable displaying minor status messages.
    vim.opt.shortmess:append("c")

    -- Disable automatically continuing comment blocks after hitting enter.
    vim.opt.formatoptions:remove({ "c", "r", "o" })

    -- Use ripgrep if available
    if vim.fn.executable("rg") == 1 then
        vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case --hidden"
        vim.opt.grepformat = "%f:%l:%c:%m"
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
end

return M
