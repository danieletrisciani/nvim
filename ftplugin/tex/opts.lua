

local width = 4

vim.opt.wrap = true -- Enable wrap
vim.opt_local.expandtab = true      -- Usa spazi invece di tab
vim.opt_local.tabstop = width           -- Tab = 2 spazi
vim.opt_local.shiftwidth = width        -- Indentazione = 2 spazi
vim.opt_local.softtabstop = width       -- Backspace rimuove 2 spazi
vim.opt_local.autoindent = true     -- Mantieni indentazione
vim.opt_local.smartindent = false   -- Disabilita per LaTeX
vim.opt_local.linebreak = true
vim.opt_local.relativenumber = false -- Disable relative number
vim.opt_local.number = false -- Disable number line
vim.opt_local.signcolumn = 'yes:1'
vim.wo.conceallevel = 0
vim.opt_local.concealcursor = ''

-- Highlights
-- vimtex flags a bare _ or ^ outside math as texError. Painting it black made
-- those characters invisible against the background, so mute the error
-- highlight by rendering it as ordinary text instead.
vim.api.nvim_set_hl(0, "texError", { link = "Normal" })

