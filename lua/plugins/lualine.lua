local M = {
    -- Fast and easy to configure neovim statusline plugin
    -- https://github.com/nvim-lualine/lualine.nvim
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
}

---Gets the current time.
---@return string #Returns the current time in HH:MM format.
local function time() return "  " .. os.date("%H:%M") end

---Determines if the current buffer has any LSP clients attached.
---@return boolean #Returns true if there is one or more LSP clients attached to this buffer.
local function has_lsp_clients() return #vim.lsp.get_active_clients({ bufnr = 0 }) > 0 end

---Get the names of LSP clients attached to this buffer
---@return string #Returns a string with a comma separated list of LSP client names.
local function lsp_clients()
    local buf_client_names = {}

    -- For each client attached to the current buffer
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        -- Insert the client name into the list of names
        table.insert(buf_client_names, client.name)
    end

    -- Concat the list of names into a comma separated string
    return table.concat(buf_client_names, ", ")
end

---Determines if an attached LSP client has any status messages to display.
---@return boolean #Returns true if there are any LSP messages to display.
local function has_lsp_progress()
    -- Don't bother checking for messages if there are no attached clients
    return #vim.lsp.get_active_clients({ bufnr = 0 }) > 0
        and #vim.lsp.util.get_progress_messages() > 0
end

---Report the processing progress of busy LSPs attached to the buffer.
---@return string #Returns a formatted string with the name and completion
---percentage (when available) of the operation the LSP is performing.
local function lsp_progress()
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
end

---Get the file encoding of the current buffer, ignoring UTF-8.
---@return string #Returns the file encoding of the current buffer or an empty string if the file is UTF-8.
local function encoding_override()
    local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
    return ret
end

---Get the cursor's location in the file.
---@returns string #The cursors location as `line:char (%)'
local function combined_location()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local current_col = vim.fn.virtcol(".")

    if current_line == 1 then
        return string.format(
            "󰓾 %d:%d  0%%%%",
            current_line,
            current_col,
            math.floor(current_line / total_lines * 100)
        )
    else
        return string.format(
            "󰓾 %d:%d  %d%%%%",
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
            icons_enabled = true,
            theme = "kanagawa",
            disabled_filetypes = { "telescope", "mason", "lazy" },
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                { require("lazy.status").updates, cond = require("lazy.status").has_updates },
                "branch",
                "diff",
                "diagnostics",
                {
                    function() return "" end,
                    cond = require("nvim-treesitter.parsers").has_parser,
                },
            },
            lualine_c = {
                "filename",
            },
            lualine_x = {
                { lsp_progress, cond = has_lsp_progress },
                { lsp_clients,  cond = has_lsp_clients },
            },
            lualine_y = { encoding_override, "fileformat", "filetype", time },
            lualine_z = { combined_location },
        },

        winbar = {
            lualine_y = { { "filename", path = 1, newfile_status = true } },
        },
        inactive_winbar = {
            lualine_y = { { "filename", path = 1, newfile_status = true } },
        },

        extensions = {
            "neo-tree",
            "quickfix",
            "symbols-outline",
            "nvim-dap-ui",
        },
    }

    lualine.setup(config)
end

return M
