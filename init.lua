

vim.deprecate = function() end

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
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', {desc = "Clear search highlights"})

-- What is saved in a session
vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions"

-- Inizialize Lazy and the plugins
require("config.lazy")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Assign Snacks UI functions
    vim.ui.select = require("snacks.picker").select
    vim.ui.input = require("snacks.input").input
  end,
})

-- shortcut to open Lazy
vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Open Lazy plugin manager" })
vim.keymap.set("n", "<leader>lm", "<cmd>Mason<CR>", { desc = "Open Mason"})

-- Keybindings to navigate buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true, desc = "Go to next buffer"})
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true, desc = "Go to previous buffer"})

-- Keybinding to navigate among splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Go to left window"})
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Go to right window"})
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Go to bottom window"})
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Go to top window"})

-- Keybinding to navigate among splits when in terminal mode
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { silent = true, desc = "Go to left window" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { silent = true, desc = "Go to right window" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { silent = true, desc = "Go to bottom window" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { silent = true, desc = "Go to top window" })

-- Keybinding to move line up/down 
-- Normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true, desc = "Move like down"})
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true, desc = "Move like up" })

-- Insert mode
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { silent = true, desc = "Move like down" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { silent = true, desc = "Move like up" })

-- Visual mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move like down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move like up" })

vim.keymap.set({"n", "v", "o"}, "<leader>qq", "<cmd>wqa<cr>", {silent = true, desc = "Save all and Quit neovim"})
vim.keymap.set({"n", "v", "o"}, "<leader>qw", "<cmd>wa<cr>", {silent = true, desc = "Save all and Quit neovim"})
vim.keymap.set({"n", "v", "o"}, "<leader>qm", "<cmd>qa!<cr>", {silent = true, desc = "Not save and Quit neovim"})

-- Highlight text when it is yanked
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
  group = highlight_group,
  pattern = '*',
})

-- -- Automatic save after updatetime ms
-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     if vim.bo.modifiable and vim.bo.modified then
--       vim.cmd("silent! write")
--     end
--   end,
-- })

-- Show diagnostic when the cursor is over a source of errors/warnings
-- vim.api.nvim_create_autocmd("CursorHold", {
--   buffer = bufnr,
--   callback = function()
--     local opts = {
--       focusable = false,
--       close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
--       border = 'rounded',
--       source = 'always',
--       prefix = ' ',
--       scope = 'cursor',
--     }
--     vim.diagnostic.open_float(nil, opts)
--   end
-- })
