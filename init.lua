
-- Create a command to show the highlight group for the element under the cursor. 
local hitex = 'echo synIDattr(synID(line("."), col("."), 1), "name")'
vim.api.nvim_create_user_command("Hig", hitex, {})

-- Cursor settings. This enables the cursor blinking in every mode.
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor,a:blinkwait500-blinkoff500-blinkon500"

---- START OF init.lua ----
-- User defined global variables --
vim.g.auto_save = true

-- set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>')

-- shows the number bar and set relativenumber
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2 -- indentation size for >>, <<, autoindent
vim.opt.scrolloff = 4

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

-- Break indent for wrap lines
vim.o.breakindent = true

-- Disable wrap
vim.opt.wrap = false

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in terminal
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'number'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- What is saved in a session
vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,winpos,terminal"

-- Inizialize Lazy and the plugins
require("config.lazy")

-- Run autocmds
require("autocmds")

-- Set keybindings
require("binds")

vim.diagnostic.config({
    -- Stop diagnostics from updating while you're typing
    update_in_insert = false,
    signs = false,

    -- Prevent the diagnostic engine from being too aggressive
    virtual_text = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

--------------------
---Highlights-------
--------------------
vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1a1b26", bold = true })
vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#1a1b26", bold = true })
vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { bg = "#1a1b26", bold = true })
vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = "#e0af68"})
vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#e0af68"})
vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { fg = "#e0af68"})
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1b26" })

-- Load the colorscheme
vim.cmd("colorscheme gruvbox")

-- Adds a colored line after the context line
vim.cmd([[
  hi TreesitterContextBottom gui=underline guisp=Grey
  hi TreesitterContextLineNumberBottom gui=underline guisp=Grey
]])

