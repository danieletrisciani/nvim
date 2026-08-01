local au_group = vim.api.nvim_create_augroup("vimtex_events", {})

-- Focus the terminal after inverse search (Hyprland/Wayland)

---PID of the terminal: nvim's grandparent (nvim ← fish ← kitty).
local function terminal_pid()
    local function ppid_of(pid)
        local stat = vim.fn.readfile("/proc/" .. pid .. "/stat")[1]
        return tonumber(stat:match("%)%s+%S+%s+(%d+)"))
    end
    return ppid_of(ppid_of(ppid_of(vim.fn.getpid())))
end

-- Terminal can't change during the session: compute once.
local term_pid = terminal_pid()

vim.api.nvim_create_autocmd("User", {
    pattern = "VimtexEventViewReverse",
    group = au_group,
    callback = function()
        if not term_pid then return end
        vim.notify("pid: " .. term_pid)
        vim.fn.system({
            "hyprctl", "eval",
            'hl.dispatch(hl.dsp.focus({ window = "pid:' .. term_pid .. '" }))',
        })
    end,
})

-- Copy compiled PDF to cloud on successful vimtex compile,
-- named after the project folder

local techdocs = vim.fn.expand('~/cloud/Documents/Techdocs')

-- After successful compilation, copy the pdf output to a friendlier folder
vim.api.nvim_create_autocmd('User', {
    pattern = 'VimtexEventCompileSuccess',
    callback = function()
        local vt = vim.b.vimtex
        if not vt then return end
        local root = vt.root
        local pdf = root .. '/build/main.pdf'
        if vim.fn.filereadable(pdf) == 0 then return end
        local name = vim.fn.fnamemodify(root, ':t') .. '.pdf'
        vim.fn.mkdir(techdocs, 'p')
        vim.fn.system({ 'cp', pdf, techdocs .. '/' .. name })
        if vim.v.shell_error ~= 0 then
            vim.notify('Techdocs copy failed: ' .. name, vim.log.levels.ERROR)
        end
    end,
})

-- Events for the vimtex compilation indicator in lualine label 

vim.api.nvim_create_autocmd('User', {
    pattern = 'VimtexEventQuit',
    callback = function()
        vim.g.compile_status = nil
        require("lualine").refresh()
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'VimtexEventCompiling',
    callback = function()
        vim.g.compile_status = 'compiling'
        vim.g.compile_status_color = '#ed8796'
        require("lualine").refresh()
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'VimtexEventCompileStopped',
    callback = function()
        vim.g.compile_status = nil
        require("lualine").refresh()
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'VimtexEventCompileSuccess',
    callback = function()
        vim.g.compile_status_color = '#a6da95'
        require("lualine").refresh()
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'VimtexEventCompileFailed',
    callback = function()
        vim.g.compile_status_color = '#ed8796'
        require("lualine").refresh()
    end,
})

