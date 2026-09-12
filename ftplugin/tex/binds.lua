
-- Copy build PDF to /tmp with title name and clip it
local clip_pdf =  function()
  local pdf = vim.fn.expand("%:p:h") .. "/build/main.pdf"
  if vim.fn.filereadable(pdf) == 0 then
    return vim.notify("PDF not found: " .. pdf, vim.log.levels.ERROR)
  end

  local title = vim.fn.system({ "pdfinfo", pdf }):match("Title:%s*([^\n]-)%s*\n")
  if not title or title == "" then
    title = table.concat(vim.fn.readfile(vim.fn.expand("%:p"))):match("\\title%s*{(.-)}")
  end
  title = (title and title ~= "" and title or "main")
    :gsub("[/\\%c]", ""):gsub("%s+", "_")

  local dest = "/tmp/" .. title .. ".pdf"
  vim.fn.system({ "cp", pdf, dest })
    vim.fn.system({ "fish", "-c", "clipfile " .. vim.fn.shellescape(dest) })
  vim.notify("Clipped pdf")
end

--- Compilation mappings ---

-- Table of Content
vim.keymap.set('n', '<leader>ll', '<Plug>(vimtex-compile)', {
  buffer = true,
  desc = 'Compile',
})

vim.keymap.set({'n', 'x'}, '<leader>lL', '<Plug>(vimtex-compile-selected)', {
  buffer = true,
  desc = 'Compile selected',
})

vim.keymap.set('n', '<leader>lL', '<Plug>(<plug>(vimtex-compile-ss)', {
  buffer = true,
  desc = 'Compile single shot',
})

-- Table of Content
vim.keymap.set('n', '<leader>lt', '<Plug>(vimtex-toc-open)', {
  buffer = true,
  desc = 'TOC',
})

-- Info 
vim.keymap.set('n', '<leader>li', '<Plug>(vimtex-info)', {
  buffer = true,
  desc = 'Info',
})

-- View the generated PDF
vim.keymap.set('n', '<leader>lv', '<Plug>(vimtex-view)', {
  buffer = true,
  desc = 'View',
})

-- Shows VimTex LOG
vim.keymap.set('n', '<leader>lq', '<Plug>(vimtex-log)', {
  buffer = true,
  desc = 'Log',
})

-- Stop continuos compilation
vim.keymap.set('n', '<leader>lk', '<Plug>(vimtex-stop)', {
  buffer = true,
  desc = 'Stop',
})

vim.keymap.set('n', '<leader>le', function()
  local cur_win = vim.api.nvim_get_current_win()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vimtex-errors)', true, false, true), '')
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(cur_win) then
      vim.api.nvim_set_current_win(cur_win)
    end
  end, 50)  -- small delay to let the quickfix window actually open first
end, {
  buffer = true,
  desc = 'Errors',
})

-- Compile already compiled output
vim.keymap.set('n', '<leader>lo', '<Plug>(vimtex-compile-output)', {
  buffer = true,
  desc = 'Compile output',
})

-- Shows VimTex status
vim.keymap.set('n', '<leader>lg', '<Plug>(vimtex-status)', {
  buffer = true,
  desc = 'Status',
})

-- Clean the quickfix log
vim.keymap.set('n', '<leader>lc', '<Plug>(vimtex-clean)', {
  buffer = true,
  desc = 'Clean',
})

-- Clean the quickfix log
vim.keymap.set('n', '<leader>lC', '<Plug>(vimtex-clean-full)', {
  buffer = true,
  desc = 'Clean full',
})

-- Shows insert mode mappings
vim.keymap.set('n', '<leader>lm', '<Plug>(vimtex-imaps-list)', {
  buffer = true,
  desc = 'imaps list',
})

-- Shows main file for the current project
vim.keymap.set('n', '<leader>lm', '<Plug>(vimtex-toggle-main)', {
  buffer = true,
  desc = 'imaps list',
})

-- Open the context menu
vim.keymap.set('n', '<leader>la', '<Plug>(vimtex-context-menu)', {
  buffer = true,
  desc = 'Context menu',
})

-- Clip generated pdf
vim.keymap.set('n', '<leader>lp', clip_pdf, {
  buffer = true,
  desc = 'Clip pdf',
})

vim.keymap.set('n', '<leader>lf', function()
  vim.fn['vimtex#fzf#run']()
end, { silent = true })

-- vimtex's #X and `X insert maps only ever expand inside math mode (they all
-- go through vimtex#syntax#in_mathzone), but the mappings exist everywhere.
-- So a literal # or ` typed in text mode stalls for 'timeoutlen' while Neovim
-- waits to see whether a second key follows. Keep every mapping, but only
-- install them while the cursor is actually in a math zone.
local buf = vim.api.nvim_get_current_buf()
vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(buf) then
        return
    end

    local saved = {}
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(buf, 'i')) do
        local leader = map.lhs:sub(1, 1)
        if (leader == '#' or leader == '`') and #map.lhs > 1 then
            saved[#saved + 1] = vim.fn.maparg(map.lhs, 'i', false, true)
        end
    end
    if #saved == 0 then
        return
    end

    -- The maps only exist while in math mode, so `:imap #` from normal mode
    -- finds nothing. Keep the captured list inspectable:
    --   :lua =vim.tbl_map(function(m) return m.lhs end, vim.b.math_imaps)
    vim.b[buf].math_imaps = saved

    local installed = true
    local function install(want)
        if want == installed then
            return
        end
        for _, map in ipairs(saved) do
            if want then
                vim.fn.mapset('i', false, map)
            else
                pcall(vim.keymap.del, 'i', map.lhs, { buffer = buf })
            end
        end
        installed = want
    end

    install(false)

    vim.api.nvim_create_autocmd({ 'InsertEnter', 'CursorMovedI' }, {
        buffer = buf,
        callback = function()
            install(vim.fn['vimtex#syntax#in_mathzone']() == 1)
        end,
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
        buffer = buf,
        callback = function()
            install(false)
        end,
    })
end)
