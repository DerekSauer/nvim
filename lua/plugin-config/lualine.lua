local lualine_ok, lualine = pcall(require, "lualine")

if lualine_ok then
    -- Get a list of registered null-ls providers for a filetype
    -- and the methods (formatting, diagnostics, etc...) they provide for that filetype
    -- https://github.com/AstroNvim/AstroNvim/blob/176265812355a53559497c0f0ada7ab62a2d1ba8/lua/core/utils/init.lua#L407
    local sources_ok, sources = pcall(require, "null-ls.sources")
    local function get_null_ls_providers(filetype)
        local registered = {}

        if sources_ok then
            -- Iterate through each source registered for this filetype
            for _, source in ipairs(sources.get_available(filetype)) do
                -- Associate a source name with the methods it provides (formatting, diagnostics, etc...)
                for method in pairs(source.methods) do
                    -- Don't repeat an existing method
                    registered[method] = registered[method] or {}
                    table.insert(registered[method], source.name)
                end
            end
        end

        return registered
    end

    -- Get the null-ls source for a given null-ls method
    -- https://github.com/AstroNvim/AstroNvim/blob/176265812355a53559497c0f0ada7ab62a2d1ba8/lua/core/utils/init.lua#L429
    local methods_ok, methods = pcall(require, "null-ls.methods")
    local function get_null_ls_sources(filetype, method)
        if methods_ok then
            return get_null_ls_providers(filetype)[methods.internal[method]]
        else
            return {}
        end
    end

    -- Get the names of LSP clients attached to this buffer
    -- https://github.com/AstroNvim/AstroNvim/blob/176265812355a53559497c0f0ada7ab62a2d1ba8/lua/core/utils/status.lua#L519
    local function lsp_clients()
        local buf_client_names = {}

        -- For each client attached to the current buffer
        for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            -- Null-ls clients need special handling
            if client.name == "null-ls" then
                local null_ls_sources = {}

                -- Add matching formatting and diagnostics sources; completion is handled by regular LSP
                for _, type in ipairs({ "FORMATTING", "DIAGNOSTICS" }) do
                    for _, source in ipairs(get_null_ls_sources(vim.bo.filetype, type)) do
                        null_ls_sources[source] = true
                    end
                end
                vim.list_extend(buf_client_names, vim.tbl_keys(null_ls_sources))
            else
                table.insert(buf_client_names, client.name)
            end
        end

        return table.concat(buf_client_names, ", ")
    end

    -- Report processing progress of the LSP
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
                return string.format("LSP: %s %s", lsp_message.title or "", lsp_message.message or "")
            end
        else
            return ""
        end
    end

    -- Don't show encoding if its utf-8
    local function encoding_override()
        local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
        return ret
    end

    -- Don't show file format if its unix
    local function fileformat_override()
        local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
        return ret
    end

    -- Output navic code location string if it is available
    local navic_ok, navic = pcall(require, "nvim-navic")
    local function navic_string()
        if navic_ok then
            return navic.is_available() and navic.get_location() or ""
        else
            return ""
        end
    end

    -- Output trimmed buffer name
    local function buffer_name()
        return require("globals").trimmed_buffer_name(0)
    end

    -- Display an icon if a tree-sitter parser is available for this buffer.
    local ts_loaded, treesitter = pcall(require, "nvim-treesitter.parsers")
    local function treesitter_status()
        if ts_loaded then
            return treesitter.has_parser() and "" or ""
        else
            return ""
        end
    end

    local config = {
        options = {
            theme = "catppuccin",
            disabled_filetypes = { "neo-tree", "telescope", "mason" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { treesitter_status, "filename" },
            lualine_x = { lsp_progress, lsp_clients },
            lualine_y = { encoding_override, fileformat_override, "filetype", "progress" },
            lualine_z = { "location" },
        },

        winbar = {
            lualine_c = { navic_string },
            lualine_x = { buffer_name },
        },
        inactive_winbar = {
            lualine_x = { buffer_name },
        }, -- TODO: Add trimmed file path
    }

    lualine.setup(config)
else
    vim.notify("Failed to load plugin: lualine.", vim.log.levels.ERROR)
    lualine = nil
end
