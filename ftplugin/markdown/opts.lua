-- Enable wrap
vim.opt.wrap = true

local width = 4

vim.opt_local.expandtab = true      -- Usa spazi invece di tab
vim.opt_local.tabstop = width           -- Tab = 2 spazi
vim.opt_local.shiftwidth = width        -- Indentazione = 2 spazi
vim.opt_local.softtabstop = width       -- Backspace rimuove 2 spazi
vim.opt_local.autoindent = true     -- Mantieni indentazione
vim.opt_local.linebreak = true
vim.opt_local.relativenumber = false
vim.opt_local.number = false
vim.wo.conceallevel = 2
vim.opt.concealcursor = ''

vim.api.nvim_set_hl(0, 'ObsidianTag', { fg = '#e0af68', bold = true })
