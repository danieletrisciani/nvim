---------------------------
------ CUSTOM BINDS -------
---------------------------

local fn = require("funcs")

-- Create new group of binds
local wk = require("which-key")
wk.add({ { "<leader>mn", group = "New Project" }, })

-- Disable VimTex mappings
vim.g.vimtex_mappings_enabled = 0

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', {desc = "Clear search highlights"})

-- Use a wrapper function so these ONLY run when you press the keys
vim.keymap.set('n', '<leader>mnp', function() fn.new_project("Python") end, { desc = " Python project" })
vim.keymap.set('n', '<leader>mnl', function() fn.new_project("Latex") end, { desc = " Latex project" })
vim.keymap.set('n', '<leader>mnc', function() fn.new_project("Cpp") end, { desc = " C++ project" })

-- Shortcuts for WezTerm splits
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)

-- Shortcut to open Lazy
vim.keymap.set("n", "<leader>ml", "<cmd>Lazy<CR>", { desc = "Open Lazy plugin manager" })
vim.keymap.set("n", "<leader>mm", "<cmd>Mason<CR>", { desc = "Open Mason"})
vim.keymap.set('n', '<leader>md', '<cmd>:lua Snacks.dashboard()<cr>', { desc = "Open Dashboard" })

-- Toggle between the last two buffers with Backspace
vim.keymap.set('n', '<BS>', '<C-^>', { desc = 'Toggle last buffer' })

vim.keymap.set('n', '<leader>bb', '<cmd>w<cr>', { desc = 'Save buffer' })
vim.keymap.set('n', '<leader>bc', '<cmd>bp|bd #<cr>', { desc = 'Close current buffer' })
vim.keymap.set('n', '<leader>ba', '<cmd>%bd|e#|bd#<cr>|\'"', { desc = 'Close buffers except current' })
vim.keymap.set('n', '<leader>bn', fn.new_buffer, { desc = 'New buffer' })

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

-- Exit vim
vim.keymap.set({"n", "v", "o"}, "<leader>q", "<cmd>wqa<cr>", {silent = true, desc = "Save all and Quit neovim"})
vim.keymap.set({"n", "v", "o"}, "<leader>Q", "<cmd>qa!<cr>", {silent = true, desc = "Not save and Quit neovim"})

-- Put method at the top of the screen
vim.keymap.set({"n"}, "zn", "[mz<cr>", {silent = true, desc = "Put the screen at the top"})

-- Keybindings for the TreeJS plugin.
vim.keymap.set('n', '<leader>ct', require('treesj').toggle, {desc="Toogle node under cursor"})
vim.keymap.set('n', '<leader>cs', require('treesj').split, {desc="Split node under cursor"})
vim.keymap.set('n', '<leader>cj', require('treesj').join, {desc="Join node under cursor"})

-- Code actions

vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc="Code actions"})

-- Yank the whole screen
vim.keymap.set('n', '<leader>cy', '<cmd>%y+<cr>', {desc="Yank whole buffer"})

-- More confortable mapping for held page down and up
vim.keymap.set({'n', 'v'}, '<A-i>', '<c-d>', {desc="Yank whole buffer"})
vim.keymap.set({'n', 'v'}, '<A-o>', '<c-u>', {desc="Yank whole buffer"})

-- Alt+Backspace to delete a work backward
vim.keymap.set('i', '<M-BS>', '<C-w>', { desc = 'Delete word backward' })

-- Toggle concealing
vim.keymap.set("n", '<leader>uc', fn.toggle_conceal, { desc = 'Toogle Concealing', })

-- Toogle lualine
vim.keymap.set('n', '<leader>mb', fn.toggle_lualine, { desc = 'Toggle Lualine' })

-- Go to next and previous diagnostic in file
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count= -1,float = true}) end, { desc = 'Prev diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count= 1,float = true}) end, { desc = 'Next diagnostic' })

-- Go to first and last diagnostic in file
vim.keymap.set('n', '[D', function() vim.diagnostic.goto_prev({ count = math.huge }) end, { desc = 'First diagnostic' })
vim.keymap.set('n', ']D', function() vim.diagnostic.goto_next({ count = math.huge }) end, { desc = 'Last diagnostic' })

vim.keymap.set('n', 'gm', vim.lsp.buf.rename, { desc = 'Rename' })

vim.keymap.set('n', '<leader>ua', fn.toggle_autosave, { desc = "Toggle Auto-save" })

-- Without this <C-i> is mapped to something else from the terminal
vim.keymap.set('n', '<C-i>', '<C-i>', { noremap = true })

-- Keybindings for managing sessions
vim.keymap.set({'n', 'v'}, '<leader>fs', fn.new_session, {desc="Save/Create session"})
vim.keymap.set({'n', 'v'}, '<leader>fl', fn.restore_session, {desc="Load session of current cwd"})

-- Open the list of sessions
vim.keymap.set({'n', 'v'}, '<leader>w', fn.picker_session, {desc="List sessions"})

-- Open new terminal tab in same cwd
vim.keymap.set({'n'}, '<leader>fd', fn.new_tab, {desc="New terminal tab"})

-- Obsidian binds
vim.keymap.set('n', '<leader>oo', '<cmd>Obsidian quick_switch<cr>', {desc="Find note"} )
vim.keymap.set('n', '<leader>od', '<cmd>Obsidian today<cr>', {desc="Today note"} )
vim.keymap.set('n', '<leader>oD', '<cmd>Obsidian yesterday<cr>', {desc="Yesterday note"} )
vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian tags<cr>', {desc="Search tags"} )
vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<cr>', {desc="Search in notes"} )
vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new<cr>', {desc="New note"} )
vim.keymap.set('n', '<leader>op', '<cmd>Obsidian<cr>', {desc="Obsidian palette"} )

vim.keymap.set('n', '<leader>ar', fn.toggle_auto_refresh, { noremap = true, desc = "Toggle auto refresh of files" })

--- Harpoon binds ---
local harpoon = require("harpoon")

vim.keymap.set( "n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon list" })

fn.set_harpoon_keymaps()

--- todo-comments keybindings
local fn_todo = require("todo-comments")

vim.keymap.set("n", "]t", function() fn_todo.jump_next() end, { desc = "TODO comment" })

vim.keymap.set("n", "[t", function() fn_todo.jump_prev() end, { desc = "TODO comment" })
