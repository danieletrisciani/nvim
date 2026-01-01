
-- START OF init.lua --
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

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', {desc = "Clear search highlights"})

-- What is saved in a session
vim.o.sessionoptions = "blank,buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions"

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

-- In insert mode: Shift+Tab per de-indent
vim.keymap.set('i', '<S-Tab>', '<C-d>', { desc = 'De-indent line' })

-- In normal mode: Tab and Shift-Tab also in normal mode
vim.keymap.set('n', '<S-Tab>', '<<', { desc = 'De-indent line' })
vim.keymap.set('n', 'Tab', '>>', { desc = 'De-indent line' })

-- Shortcuts for WezTerm splits
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)

-- Shortcut to open Lazy
vim.keymap.set("n", "<leader>ml", "<cmd>Lazy<CR>", { desc = "Open Lazy plugin manager" })
vim.keymap.set("n", "<leader>mm", "<cmd>Mason<CR>", { desc = "Open Mason"})
vim.keymap.set('n', '<leader>md', '<cmd>:lua Snacks.dashboard()<cr>', { desc = "Open Dashboard" })

-- Keybindings to navigate buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true, desc = "Go to next buffer"})
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true, desc = "Go to previous buffer"})

-- Toggle between the last two buffers with Backspace
vim.keymap.set('n', '<BS>', '<C-^>', { desc = 'Toggle last buffer' })

vim.keymap.set('n', '<leader>bb', '<cmd>w<cr>', { desc = 'Save buffer' })
vim.keymap.set('n', '<leader>bc', '<cmd>bp|bd #<cr>', { desc = 'Close current buffer' })
vim.keymap.set('n', '<leader>ba', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close buffers except current' })
vim.keymap.set('n', '<leader>bn', function ()
  vim.ui.input(
  { prompt = "New buffer name: " },
  function(input)
    if input == nil or input == '' then
      return
    end
    vim.cmd("edit " .. vim.fn.fnameescape(input))
    print("You entered:", input)
  end
)
end, { desc = 'New buffer' })

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

-- Yank the whole screen
vim.keymap.set('n', '<leader>ce', '<cmd>%y+<cr>', {desc="Yank whole buffer"})

-- More confortable mapping for held page down and up
vim.keymap.set({'n', 'v'}, '<A-i>', '<c-d>', {desc="Yank whole buffer"})
vim.keymap.set({'n', 'v'}, '<A-o>', '<c-u>', {desc="Yank whole buffer"})

-- Alt+Backspace to delete a work backward
vim.keymap.set('i', '<M-BS>', '<C-w>', { desc = 'Delete word backward' })

-- Keybindings for managing sessions
vim.keymap.set({'n', 'v'}, '<leader>fs', function() vim.cmd("SessionManager save_current_session") end, {desc="Save/Create session"})
vim.keymap.set({'n', 'v'}, '<leader>fl', function() vim.cmd("SessionManager load_current_dir_session") end, {desc="Load session of current cwd"})

-- Open the list of sessions
vim.keymap.set({'n', 'v'}, '<leader>w', function()
  require("snacks").picker.pick({
    title = "Sessions",
    name = "picker-sessions",
    finder = function ()

      local utils = require('session_manager.utils')
      local sessions = utils.get_sessions()
      local items = {}

      for index, session in ipairs(sessions) do
	table.insert(items, {
	  idx = index,
	  file = utils.shorten_path(session.dir),
	  text = session.filename,
	})
      end

      return items
    end,
    -- After pressing enter
    confirm = function(picker, item)
      local utils = require('session_manager.utils')
      local session = require('session_manager')
      session.save_current_session()

      utils.load_session(item.text, true)
      picker:close()
    end,
    format = "filename",
    layout = {
      backdrop = true,
      hidden = { "preview" },
      layout = {
	backdrop = false,
	row = 3,
	width = 0.4,
	min_width = 30,
	min_height = 2,
	height = function ()
	  local sessions = require('session_manager.utils').get_sessions()
	  return #sessions + 2
	end,
	border = true,
	box = "vertical",
	title = "{title} {live} {flags}",
	{ win = "input", height = 1, border = "bottom"},
	{ win = "list", border = "hpad" },
      },
    },
    icons = {
      files = {
	enabled = false,
      }
    },
    formatters = {
      file = {
	filename_only = true,
      }
    },
    -- Keys to manipulat the sessions
    win = {
      input = {
        keys = {
          -- ["<C-x>"] = {"delete_session", mode = { "n", "i" }, desc = "delete session"},
          -- ["dd"] = {"delete_session", mode = { "n" }, desc = "delete session"},
        },
      },
    },
    -- Azione quando selezioni
    -- actions = {
    -- default = function(picker, item)
    --   print("Selected: " .. item)
    -- end,
    -- },
  })
end, {desc="List sessions"})

-- Toogle lualine
vim.keymap.set('n', '<leader>mb', function()
  if vim.o.laststatus == 0 then
    vim.o.laststatus = 3  -- o 2 per statusline per finestra
  else
    vim.o.laststatus = 0
  end
end, { desc = 'Toggle Lualine' })

-- Diagnostic
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

vim.keymap.set('n', '[D', function()
  vim.diagnostic.goto_prev({ count = math.huge })
end, { desc = 'First diagnostic' })
vim.keymap.set('n', ']D', function()
  vim.diagnostic.goto_next({ count = math.huge })
end, { desc = 'Last diagnostic' })

vim.keymap.set('n', 'gm', vim.lsp.buf.rename, { desc = 'Rename' })

-- Disable diagnostic signs
vim.diagnostic.config({
  signs = false,
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

-- Automatic save after updatetime ms
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    if vim.bo.modifiable and vim.bo.modified then
      vim.cmd("silent! write")
    end
  end,
})

-- Create a new folder is saving a file in a folder that does not exist
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

vim.cmd([[
  hi TreesitterContextBottom gui=underline guisp=Grey
  "hi TreesitterContextLineNumberBottom gui=underline guisp=Grey
]])

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
--
