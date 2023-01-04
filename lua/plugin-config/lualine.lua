local lualine_ok, lualine = pcall(require, "lualine")
local navic_ok, navic = pcall(require, "nvim-navic")
local ts_loaded, treesitter = pcall(require, "nvim-treesitter.parsers")

if lualine_ok then
    ---Get the names of LSP clients attached to this buffer
    ---@return string #Returns a string with a comma separated list of LSP client names.
    local function lsp_clients()
        local buf_client_names = {}

        -- For each client attached to the current buffer
        for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            -- Null-ls clients will simply display "null-ls", we need to dig deeper for the
            -- "server" null-ls is using internally
            if client.name == "null-ls" then
                -- Iterate through the null-ls sources for this buffer's filetype
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

        return table.concat(buf_client_names, ", ")
    end

    ---Report the processing progress of busy LSPs attached to the buffer.
    ---@return string #Returns a formatted string with the name and completion
    ---percentage (when available) of the operation the LSP is performing.
    local function lsp_progress()
        -- Grab the first LSP message off the queue
        local lsp_message = vim.lsp.util.get_progress_messages()[1]

        -- If the message has a completion percentage, add it
        if lsp_message then
            if lsp_message.percentage then
                return string.format(
                    "LSP: %s %s (%s%%%%)",
                    lsp_message.title or "",
                    lsp_message.message or "",
                    lsp_message.percentage or ""
                )
            else
                return string.format(
                    "LSP: %s %s",
                    lsp_message.title or "",
                    lsp_message.message or ""
                )
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
        if navic_ok then
            return navic.is_available() and navic.get_location() or ""
        else
            return ""
        end
    end

    ---Get an icon if a tree-sitter parser is available for this buffer.
    ---@return string #Returns an icon if a parser is available for this buffer or an empty string.
    local function treesitter_status()
        if ts_loaded then
            return treesitter.has_parser() and "" or ""
        else
            return ""
        end
    end

    local config = {
        options = {
            theme = "kanagawa",
            disabled_filetypes = { "telescope", "mason" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { treesitter_status, "filename" },
            lualine_x = { lsp_progress, lsp_clients },
            lualine_y = { encoding_override, "fileformat", "filetype", "progress" },
            lualine_z = { "location" },
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
else
    vim.notify("Failed to load plugin: lualine.", vim.log.levels.ERROR)
    lualine = nil
end
