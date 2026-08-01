
-- Assign Snacks UI functions
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        vim.ui.select = require("snacks.picker").select
        vim.ui.input = require("snacks.input").input
    end,
})

-- Automatic save
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        -- Check if it's a LaTeX file
        -- if vim.bo.filetype == "tex" then
        --   return
        -- end

        -- Save only if the buffer is modifiable and has unsaved changes
        if vim.g.auto_save and vim.bo.modifiable and vim.bo.modified then
            vim.cmd("silent! write")
        end
    end,
})

-- Create a new folder when saving a file in a folder that does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        if event.match:match("^%w%w+:[//?]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Prevent duplicate autocommands on reload
local luasnip_undo_group = vim.api.nvim_create_augroup("LuaSnipUndo", { clear = true })

vim.api.nvim_create_autocmd("User", {
    pattern = "LuasnipPreExpand",
    group = luasnip_undo_group,
    callback = function()
        -- Break the undo sequence right before the snippet expands
        local keys = vim.api.nvim_replace_termcodes("<C-g>u", true, true, true)
        vim.api.nvim_feedkeys(keys, "i", true)
    end,
})

-- Latex command environment colors
-- This avoid the color is overwritten by color scheme
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- Change 'fg' to whatever hex code you prefer
        -- 'bold = true' helps make structure stand out
        vim.api.nvim_set_hl(0, "texCmdEnv", { fg = "#8ec07c", bold = true })
    end,
})

-- Fix: guard diagnostic autocmd cleanup on buffer close
-- local orig = vim.api.nvim_del_autocmd
-- vim.api.nvim_del_autocmd = function(id)
--   pcall(orig, id)
-- end

-- Creates undo breakpoint before every snippet expansion
local api = vim.api

local g = api.nvim_create_augroup("personal-luasnip", { clear = true })
api.nvim_create_autocmd("User", {
    group = g,
    pattern = "LuasnipPreExpand",
    callback = function()
        vim.go.undolevels = vim.go.undolevels
    end,
})

-- Show diagnostic when the cursor is over a source of errors/warnings
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
    end
})

-- Highlight text when it is yanked
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Save and close buffers when changing cwd
vim.api.nvim_create_autocmd('DirChangedPre', {
    callback = function(_)
        local utils = require('session_manager.utils')
        if utils.exists_in_session() then
            vim.cmd("SessionManager save_current_session")
            vim.cmd("silent! %bd!")
        end
    end,
})

vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
  callback = function()
    require("lualine").refresh()
  end,
})

vim.api.nvim_create_autocmd("SwapExists", {
    callback = function()
        local info = vim.fn.swapinfo(vim.v.swapname)
        local file = vim.fn.fnamemodify(vim.fn.expand("<afile>"), ":p")
        local swap = vim.v.swapname
        local owned = info.pid and info.pid > 0 and info.pid ~= vim.fn.getpid()


        vim.v.swapchoice = "o"   -- always: silent, nothing aborts

        vim.schedule(function()
            local buf = vim.fn.bufnr(file)   -- the buffer that just opened RO

            if owned then
                if buf > 0 then
                    vim.api.nvim_buf_delete(buf, { force = true })
                end
                vim.notify(("%s is open in another instance (pid %d)")
                    :format(vim.fn.fnamemodify(file, ":t"), info.pid),
                    vim.log.levels.WARN)
                local ok, snacks = pcall(require, "snacks")
                if ok then snacks.dashboard() end
                return
            end

            -- stale swap: ask what to do
            local actions = {
                { label = "Edit anyway (delete swap)", act = function()
                    vim.fn.delete(swap)
                    vim.cmd("edit! " .. vim.fn.fnameescape(file))
                end },
                { label = "Recover from swap", act = function()
                    vim.cmd("recover! " .. vim.fn.fnameescape(file))
                    vim.fn.delete(swap)
                end },
                { label = "Keep read-only", act = function() end },
                { label = "Close it", act = function()
                    if buf > 0 then vim.api.nvim_buf_delete(buf, { force = true }) end
                end },
            }
            vim.ui.select(actions, {
                prompt = ("Swap file found for %s"):format(vim.fn.fnamemodify(file, ":t")),
                format_item = function(item) return item.label end,
            }, function(choice)
                if choice then choice.act() end
            end)
        end)
    end,
})
