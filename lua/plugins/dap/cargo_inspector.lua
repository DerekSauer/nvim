local M = {}

---Parse the build metadata emitted by Cargo to find the executable to debug.
---@param cargo_metadata string[] An array of JSON strings emitted by Cargo.
---@return string|nil #Returns the path of the debuggable executable built by
---Cargo or nil if an executable cannot be found.
local function parse_cargo_metadata(cargo_metadata)
    -- Iterate backwards through the metadata list since the executable
    -- will likely be near the end (usually second to last)
    for i = 1, #cargo_metadata do
        local json_table = cargo_metadata[#cargo_metadata + 1 - i]

        -- Some metadata lines may be blank, skip those
        if string.len(json_table) ~= 0 then
            -- Each matadata line is a JSON table,
            -- parse it into a data structure we can work with
            json_table = vim.fn.json_decode(json_table)

            -- Our binary will be the compiler artifact with an executable defined
            if json_table["reason"] == "compiler-artifact"
                and json_table["executable"] ~= vim.NIL
            then
                return json_table["executable"]
            end
        end
    end

    return nil
end

---Create the window and associated buffer and channel that will display build messages.
---@param debug_name string Name of the debug configuration. The created window will be large enough to display the whole name or the size defined in options, whichever is greater.
---@param window_options {enabled: boolean, width: number, height: number, border: string[]|string} Display options for the window.
---@return {buffer: number, window: number, channel: number}|nil #Returns the buffer that stores text for the window, the window itself, and a channel to communicate with the buffer. Returns nil on failure.
---@return string|nil If an error occurs, return a string with the error message, otherwise return nil.
local function create_window(debug_name, window_options)
    -- Create the buffer the will receive Cargo's build messages
    local new_buffer = vim.api.nvim_create_buf(false, true)
    if new_buffer == 0 then
        return nil, "Failed to create build progress message buffer."
    end

    -- Create a window that will display build messages from the buffer
    local window_width = math.max(#debug_name + 1, window_options.width)
    local window_height = window_options.height
    local new_window = vim.api.nvim_open_win(new_buffer, false, {
        relative = "editor",
        width = window_width,
        height = window_height,
        col = vim.api.nvim_get_option("columns") - window_width - 2,
        row = vim.api.nvim_get_option("lines")
            - vim.api.nvim_get_option("cmdheight")
            - window_options.height
            - 3,
        border = window_options.border,
        style = "minimal",
    })
    if new_window == 0 then
        return nil, "Failed to create build progress message window."
    end

    -- Open a channel to the buffer so we can send build messages to it
    local new_channel = vim.api.nvim_open_term(new_buffer, {})
    if new_channel == 0 then
        return nil, "Failed to create build progress message channel."
    end

    return { buffer = new_buffer, window = new_window, channel = new_channel }
end

---Destroy the build message window and associated buffer and channel.
---@param window_objects {buffer: number, window: number, channel: number}
local function destroy_window(window_objects)
    print(vim.inspect(window_objects))
    if window_objects.channel ~= 0 then
        vim.fn.chanclose(window_objects.channel)
        window_objects.channel = nil
    end

    if window_objects.window ~= 0 then
        vim.api.nvim_win_close(window_objects.window, { force = true })
        window_objects.window = nil
    end

    if window_objects.buffer ~= 0 then
        vim.api.nvim_buf_delete(window_objects.buffer, { force = true })
        window_objects.buffer = nil
    end
end

---@alias pipe userdata A named pipe allowing access to a process's stdout, stderr, or stdin.
---Create pipes connecting to the stdout/stderr of the various processes we're going to run.
---@return {cargo : {stdout : pipe, stderr : pipe}, rust_hash : {stdout : pipe}, rust_source : {stdout : pipe}}|nil #Table containing the various pipes or nil if an error occured.
---@return string|nil #String containing the error message if an error occured or nil if no error occured.
local function create_pipes()
    local cargo_stdout, stdout_error = vim.loop.new_pipe()
    if not cargo_stdout then
        return nil, stdout_error
    end

    local cargo_stderr, stderr_error = vim.loop.new_pipe()
    if not cargo_stderr then
        cargo_stdout:close()
        return nil, stderr_error
    end

    local rust_hash_stdout, hash_error = vim.loop.new_pipe()
    if not rust_hash_stdout then
        cargo_stderr:close()
        cargo_stdout:close()
        return nil, hash_error
    end

    local rust_source_stdout, source_error = vim.loop.new_pipe()
    if not rust_source_stdout then
        cargo_stderr:close()
        cargo_stdout:close()
        rust_hash_stdout:close()
        return nil, source_error
    end

    return {
        cargo = {
            stdout = cargo_stdout,
            stderr = cargo_stderr,
        },
        rust_hash = {
            stdout = rust_hash_stdout,
        },
        rust_source = {
            stdout = rust_source_stdout
        }
    }
end

---Destroy the named pipes created in `create_pipes()`.
---@param pipes {cargo : {stdout : pipe, stderr : pipe}, rust_hash : {stdout : pipe}, rust_source : {stdout : pipe}} A table of pipes returned by `create_pipes()`.
local function destroy_pipes(pipes)
    if pipes.rust_source.stdout ~= nil then
        pipes.rust_source.stdout:close()
        pipes.rust_source.stdout = nil
    end

    if pipes.rust_hash.stdout ~= nil then
        pipes.rust_hash.stdout:close()
        pipes.rust_hash.stdout = nil
    end

    if pipes.cargo.stderr ~= nil then
        pipes.cargo.stderr:close()
        pipes.cargo.stderr = nil
    end

    if pipes.cargo.stdout ~= nil then
        pipes.cargo.stdout:close()
        pipes.cargo.stdout = nil
    end
end

---Callback called when the Cargo process emits data to stdout. Cargo emits build process metadata to stdout.
---@param error string|nil If not nil, an error occured and `error` is a string containing the error message.
---@param data string Data emitted by Cargo to stdout.
---@return nil #Returns early without processing `data` if an error occurs.
local function cargo_stdout(error, data)
    if error then
        vim.api.nvim_err_writeln("Cargo Inspector: Error in Cargo's stdout callback\n" .. error)
        return
    end

    print("Cargo stdout datatype: " .. type(data) .. "\n")
end

---Callback called when the Cargo process emits data to stderr. Cargo emits build progress messages to stderr.
---@param error string|nil If not nil, an error occured and `error` is a string containing the error message.
---@param data string Data emitted by Cargo to stderr.
---@return nil #Returns early without processing `data` if an error occurs.
local function cargo_stderr(error, data)
    if error then
        vim.api.nvim_err_writeln("Cargo Inspector: Error in Cargo's stderr callback\n" .. error)
        return
    end

    print("Cargo stderr datatype: " .. type(data) .. "\n")
end

---Callback called when the Cargo process terminates.
---@param exit_code number The process's exit code.
---@param exit_signal number The signal that terminated the process (if any).
local function cargo_exit(exit_code, exit_signal)
    print("Cargo on exit code: " .. exit_code .. "\n")
    print("Cargo on exit signal datatype: " .. type(exit_signal) .. "\n")
end

---Parse the `cargo` table of a DAP configuration, running any Cargo tasks
---defined in the `cargo` table then extracting the debuggable binary that
---results. Also fills in Rust specific debugging hints for LLDB.
---@param dap_config table A DAP configuration with a `cargo` table.
---@param user_options table|nil The user's options for Cargo Inspector.
---@return table #Returns a DAP configuration with the debuggable binary
---defined and some additional Rust debugging hints for LLDB.
---@public
function M.inspect(dap_config, user_options)
    local final_config = vim.deepcopy(dap_config)

    -- Default options
    local options = {
        ---Options for the build progress message window.
        ---@class window
        ---@field enabled boolean Open a window to display build progress messages?
        ---@field width number Width of the window in characters.
        ---@field height number Height of the window in lines.
        ---@field border string|string[] Standard Neovim border style name or arrays of characters defining the border style.
        window = {
            enabled = true,
            width = 64,
            height = 12,
            border = require("globals").border_style,
        },
    }

    -- Extend default option with user's choices
    if user_options then
        options = vim.tbl_deep_extend('force', options, user_options)
    end

    -- Create build progress window
    local progress_window = nil
    if options.window.enabled then
        local window_error = nil
        progress_window, window_error = create_window(final_config.name, options.window)
        if not progress_window then
            vim.api.nvim_err_writeln("Cargo Inspector Window Error:\n" .. window_error)
        end
    end

    -- Create pipes that will recieve data from our external processes
    local pipes, pipe_error = create_pipes()
    if not pipes then
        vim.api.nvim_err_writeln("Cargo Inspector Pipe Error:\n" .. pipe_error)
        return final_config
    end

    -- Instruct Cargo to emit build metadata as JSON
    if final_config.cargo.args then
        table.insert(final_config.cargo.args, "--message-format=json")
    else
        final_config.cargo.args = { "--message-format=json" }
    end

    -- Run the Cargo process
    local cargo_job, cargo_job_error = vim.loop.spawn("cargo", {
        args = final_config.cargo.args,
        stdio = { nil, pipes.cargo.stdout, pipes.cargo.stderr },
        env = final_config.cargo.env,
        cwd = final_config.cwd,
    }, cargo_exit)
    if not cargo_job then
        vim.api.nvim_err_writeln("Cargo Inspector Process Error:\n" .. cargo_job_error)
        return final_config
    end

    -- Run vim.wait(), inside the callback process stdin, stdout, and wait for the on exit to set some data in a global

    -- Destroy the named pipes
    if pipes then
        destroy_pipes(pipes)
        pipes = nil
    end

    -- Destroy build progress window
    if progress_window then
        destroy_window(progress_window)
        progress_window = nil
    end

    -- The `cargo` section of the configuration is no longer needed
    final_config.cargo = nil

    return final_config
end

-- -- Parse the `cargo` section of a DAP configuration and add any needed
-- -- information to the final configuration to be handed back to the adapter.
-- -- E.g.: When debugging a test, cargo generates a random executable name.
-- -- We need to ask cargo for the name and add it to the `program` config field
-- -- so LLDB can find it.
-- function M.old_inspect(config)
--     -- Instruct cargo to emit compiler metadata as JSON
--     local message_format = "--message-format=json"
--     if final_config.cargo.args ~= nil then
--         table.insert(final_config.cargo.args, message_format)
--     else
--         final_config.cargo.args = { message_format }
--     end
--
--     -- Build final `cargo` command to be executed
--     local cargo_cmd = { "cargo" }
--     for _, value in pairs(final_config.cargo.args) do
--         table.insert(cargo_cmd, value)
--     end
--
--     -- Run `cargo`, retaining buffered `stdout` for later processing,
--     -- and emitting compiler messages to to a window
--     local compiler_metadata = {}
--     local cargo_job = vim.fn.jobstart(cargo_cmd, {
--         clear_env = false,
--         env = final_config.cargo.env,
--         cwd = final_config.cwd,
--
--         -- Cargo emits compiler metadata to `stdout`
--         stdout_buffered = true,
--         on_stdout = function(_, data) compiler_metadata = data end,
--
--         -- Cargo emits compiler messages to `stderr`
--         on_stderr = function(_, data)
--             local complete_line = ""
--
--             -- `data` might contain partial lines, glue data together until
--             -- the stream indicates the line is complete with an empty string
--             for _, partial_line in ipairs(data) do
--                 if string.len(partial_line) ~= 0 then
--                     complete_line = complete_line .. partial_line
--                 end
--             end
--
--             if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
--                 vim.fn.appendbufline(compiler_msg_buf, "$", complete_line)
--                 vim.api.nvim_win_set_cursor(
--                     compiler_msg_window,
--                     { vim.api.nvim_buf_line_count(compiler_msg_buf), 1 }
--                 )
--                 vim.cmd("redraw")
--             end
--         end,
--
--         on_exit = function(_, exit_code)
--             -- Cleanup the compile message window and buffer
--             if vim.api.nvim_win_is_valid(compiler_msg_window) then
--                 vim.api.nvim_win_close(compiler_msg_window, { force = true })
--             end
--
--             if vim.api.nvim_buf_is_valid(compiler_msg_buf) then
--                 vim.api.nvim_buf_delete(compiler_msg_buf, { force = true })
--             end
--
--             -- If compiling succeeed, send the compile metadata off for processing
--             -- and add the resulting executable name to the `program` field of the final config
--             if exit_code == 0 then
--                 local executable_name = parse_cargo_metadata(compiler_metadata)
--                 if executable_name ~= nil then
--                     final_config.program = executable_name
--                 else
--                     vim.notify(
--                         "Cargo could not find an executable for debug configuration:\n\n\t"
--                             .. final_config.name,
--                         vim.log.levels.ERROR
--                     )
--                 end
--             else
--                 vim.notify(
--                     "Cargo failed to compile debug configuration:\n\n\t" .. final_config.name,
--                     vim.log.levels.ERROR
--                 )
--             end
--         end,
--     })
--
--     -- Get the rust compiler's commit hash for the source map
--     local rust_hash = ""
--     local rust_hash_stdout = {}
--     local rust_hash_job = vim.fn.jobstart({ "rustc", "--version", "--verbose" }, {
--         clear_env = false,
--         stdout_buffered = true,
--         on_stdout = function(_, data) rust_hash_stdout = data end,
--         on_exit = function()
--             for _, line in pairs(rust_hash_stdout) do
--                 local start, finish = string.find(line, "commit-hash: ", 1, true)
--
--                 if start ~= nil then rust_hash = string.sub(line, finish + 1) end
--             end
--         end,
--     })
--
--     -- Get the location of the rust toolchain's source code for the source map
--     local rust_source_path = ""
--     local rust_source_job = vim.fn.jobstart({ "rustc", "--print", "sysroot" }, {
--         clear_env = false,
--         stdout_buffered = true,
--         on_stdout = function(_, data) rust_source_path = data[1] end,
--     })
--
--     -- Wait until compiling and parsing are done
--     -- This blocks the UI (except for the :redraw above) and I haven't figured
--     -- out how to avoid it, yet
--     -- Regardless, not much point in debugging if the binary isn't ready yet
--     vim.fn.jobwait({ cargo_job, rust_hash_job, rust_source_job })
--
--     -- Enable visualization of built in Rust datatypes
--     final_config.sourceLanguages = { "rust" }
--
--     -- Build sourcemap to rust's source code so we can step into stdlib
--     rust_hash = "/rustc/" .. rust_hash .. "/"
--     rust_source_path = rust_source_path .. "/lib/rustlib/src/rust/"
--     if final_config.sourceMap == nil then final_config["sourceMap"] = {} end
--     final_config.sourceMap[rust_hash] = rust_source_path
--
--     -- Cargo section is no longer needed
--     final_config.cargo = nil
--
--     return final_config
-- end

return M
