
-- Enable wrap
vim.opt.wrap = true

-- ftplugin/tex.lua
vim.opt_local.expandtab = true      -- Usa spazi invece di tab
vim.opt_local.tabstop = 2           -- Tab = 2 spazi
vim.opt_local.shiftwidth = 2        -- Indentazione = 2 spazi
vim.opt_local.softtabstop = 2       -- Backspace rimuove 2 spazi
vim.opt_local.autoindent = true     -- Mantieni indentazione
vim.opt_local.smartindent = false   -- Disabilita per LaTeX
vim.opt_local.linebreak = true
vim.wo.conceallevel = 2
vim.opt.concealcursor = ''
-- vim.opt_local.laststatus = 0  -- Disable lualine

