local M = {
    -- Fast and easy to configure neovim statusline plugin
    -- https://github.com/nvim-lualine/lualine.nvim
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
}

---Gets the current time.
---@return string #Returns the current time in HH:MM format.
local function time() return " " .. os.date("%H:%M") end

---Get the names of LSP clients attached to this buffer
---@return string #Returns a string with a comma separated list of LSP client names.
local function lsp_clients()
    local buf_client_names = {}

    -- Skip all this if there are no LSPs
    if #vim.lsp.get_active_clients({ bufrn = 0 }) > 0 then
        -- For each client attached to the current buffer
        for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            -- Null-ls clients will simply display "null-ls", we need to dig deeper for the
            -- "server" null-ls is using internally
            if client.name == "null-ls" then
                -- Iterate through the null-ls sources for this buffer's filetype
                -- Don't need a pcall on this require(), since we'll never get a "null-ls" client name
                -- if null-ls isn't even loaded
                for _, source in pairs(require("null-ls.sources").get_available(vim.bo.filetype)) do
                    -- Add add the source to the client name list if it is not already there
                    if buf_client_names[source.name] == nil then
                        table.insert(buf_client_names, source.name)
                    end
                end
            else
                table.insert(buf_client_names, client.name)
            end
        end
    end

    return table.concat(buf_client_names, ", ")
end

---Report the processing progress of busy LSPs attached to the buffer.
---@return string #Returns a formatted string with the name and completion
---percentage (when available) of the operation the LSP is performing.
local function lsp_progress()
    -- Skip all the work if there are no messages
    if #vim.lsp.util.get_progress_messages() > 0 then
        -- Grab the first LSP message off the queue
        local lsp_message = vim.lsp.util.get_progress_messages()[1]

        -- If the message has a completion percentage,
        -- add the percentage to the resulting message
        if lsp_message.percentage then
            return string.format(
                "LSP: %s %s (%s%%%%)",
                lsp_message.title or "",
                lsp_message.message or "",
                lsp_message.percentage or ""
            )
        else
            return string.format("LSP: %s %s", lsp_message.title or "", lsp_message.message or "")
        end
    else
        return ""
    end
end

---Get the file encoding of the current buffer, ignoring UTF-8.
---@return string #Returns the file encoding of the current buffer or an empty string if the file is UTF-8.
local function encoding_override()
    local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return ret
end

---Output Navic code location string if available.
---@return string #Returns the Navic string or an empty string if Navic is unavailable.
local function navic_string()
    local navic_ok, navic = pcall(require, "nvim-navic")
    if navic_ok then
        return navic.is_available() and navic.get_location() or ""
    else
        return ""
    end
end

---Get an icon if a tree-sitter parser is available for this buffer.
---@return string #Returns an icon if a parser is available for this buffer or an empty string.
local function treesitter_status()
    local ts_loaded, treesitter = pcall(require, "nvim-treesitter.parsers")
    if ts_loaded then
        return treesitter.has_parser() and "" or ""
    else
        return ""
    end
end

---Get the cursor's location in the file.
---@returns string #The cursors location as `line:char (%)'
local function combined_location()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local current_col = vim.fn.virtcol(".")

    if current_line == 1 then
        return string.format(
            "%d:%d (0%%%%)",
            current_line,
            current_col,
            math.floor(current_line / total_lines * 100)
        )
    else
        return string.format(
            "%d:%d (%d%%%%)",
            current_line,
            current_col,
            math.floor(current_line / total_lines * 100)
        )
    end
end

function M.config()
    local lualine = require("lualine")

    local config = {
        options = {
            theme = "kanagawa",
            disabled_filetypes = { "telescope", "mason", "lazy" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                { require("lazy.status").updates, cond = require("lazy.status").has_updates },
                "branch",
                "diff",
                "diagnostics",
            },
            lualine_c = { treesitter_status, "filename" },
            lualine_x = { lsp_progress, lsp_clients },
            lualine_y = { encoding_override, "fileformat", "filetype", time },
            lualine_z = { combined_location },
        },

        winbar = {
            lualine_c = { navic_string },
            lualine_y = { { "filename", path = 1, newfile_status = true } },
        },
        inactive_winbar = {
            lualine_y = { { "filename", path = 1, newfile_status = true } },
        },

        extensions = {
            "neo-tree",
            "quickfix",
        },
    }

    lualine.setup(config)
end

return M
