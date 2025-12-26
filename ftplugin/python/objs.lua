-- Prevent multiple loading
if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

-- Mode definitions
local move_mode = {'n', 'x', 'o'}
local capt_mode = {"x", "o"}

-- Helper functions for treesitter textobjects
local function to_prev_start(obj)
  return require("nvim-treesitter-textobjects.move").goto_previous_start(obj, 'textobjects')
end

local function to_next_start(obj)
  return require("nvim-treesitter-textobjects.move").goto_next_start(obj, 'textobjects')
end

local function to_prev_end(obj)
  return require("nvim-treesitter-textobjects.move").goto_previous_end(obj, 'textobjects')
end

local function to_next_end(obj)
  return require("nvim-treesitter-textobjects.move").goto_next_end(obj, 'textobjects')
end

local function swap()
  return require("nvim-treesitter-textobjects.swap")
end

local function capture(textobj)
  return function()
    return require("nvim-treesitter-textobjects.select").select_textobject(textobj, "textobjects")
  end
end

local function repeatable()
  return require("nvim-treesitter-textobjects.repeatable_move")
end

-- Move around functions
vim.keymap.set(move_mode, '[m', function() to_prev_start('@function.outer') end, 
  { buffer = true, desc = 'Function' })
vim.keymap.set(move_mode, ']m', function() to_next_start('@function.outer') end, 
  { buffer = true, desc = 'Function' })
vim.keymap.set(move_mode, '[M', function() to_prev_end('@function.outer') end, 
  { buffer = true, desc = 'Function end' })
vim.keymap.set(move_mode, ']M', function() to_next_end('@function.outer') end, 
  { buffer = true, desc = 'Function end' })

-- Move around calls
vim.keymap.set(move_mode, '[f', function() to_prev_start('@call.outer') end, 
  { buffer = true, desc = 'Call' })
vim.keymap.set(move_mode, ']f', function() to_next_start('@call.outer') end, 
  { buffer = true, desc = 'Call' })
vim.keymap.set(move_mode, '[F', function() to_prev_end('@call.outer') end, 
  { buffer = true, desc = 'Call end' })
vim.keymap.set(move_mode, ']F', function() to_next_end('@call.outer') end, 
  { buffer = true, desc = 'Call end' })

-- Move around parameters
vim.keymap.set(move_mode, '[a', function() to_prev_start('@parameter.outer') end, 
  { buffer = true, desc = 'Argument' })
vim.keymap.set(move_mode, ']a', function() to_next_start('@parameter.outer') end, 
  { buffer = true, desc = 'Argument' })
vim.keymap.set(move_mode, '[A', function() to_prev_end('@parameter.outer') end, 
  { buffer = true, desc = 'Argument end' })
vim.keymap.set(move_mode, ']A', function() to_next_end('@parameter.outer') end, 
  { buffer = true, desc = 'Argument end' })

-- Move around conditionals
vim.keymap.set(move_mode, '[i', function() to_prev_start('@conditional.outer') end, 
  { buffer = true, desc = 'Conditional' })
vim.keymap.set(move_mode, ']i', function() to_next_start('@conditional.outer') end, 
  { buffer = true, desc = 'Conditional' })
vim.keymap.set(move_mode, '[I', function() to_prev_end('@conditional.outer') end, 
  { buffer = true, desc = 'Conditional end' })
vim.keymap.set(move_mode, ']I', function() to_next_end('@conditional.outer') end, 
  { buffer = true, desc = 'Conditional end' })

-- Move around loops
vim.keymap.set(move_mode, '[l', function() to_prev_start('@loop.outer') end, 
  { buffer = true, desc = 'Loop' })
vim.keymap.set(move_mode, ']l', function() to_next_start('@loop.outer') end, 
  { buffer = true, desc = 'Loop' })
vim.keymap.set(move_mode, '[L', function() to_prev_end('@loop.outer') end, 
  { buffer = true, desc = 'Loop end' })
vim.keymap.set(move_mode, ']L', function() to_next_end('@loop.outer') end, 
  { buffer = true, desc = 'Loop end' })

-- Move around class
vim.keymap.set(move_mode, '[c', function() to_prev_start('@class.outer') end, 
  { buffer = true, desc = 'Class' })
vim.keymap.set(move_mode, ']c', function() to_next_start('@class.outer') end, 
  { buffer = true, desc = 'Class' })
vim.keymap.set(move_mode, '[C', function() to_prev_end('@class.outer') end, 
  { buffer = true, desc = 'Class end' })
vim.keymap.set(move_mode, ']C', function() to_next_end('@class.outer') end, 
  { buffer = true, desc = 'Class end' })

-- Swap parameters
vim.keymap.set('n', "<leader>oa", function() swap().swap_next('@parameter.inner') end, 
  { buffer = true, desc = 'Swap next argument' })
vim.keymap.set('n', "<leader>pa", function() swap().swap_previous('@parameter.inner') end, 
  { buffer = true, desc = 'Swap prev argument' })

-- Swap functions
vim.keymap.set('n', "<leader>om", function() swap().swap_next('@function.outer') end, 
  { buffer = true, desc = 'Swap next functions' })
vim.keymap.set('n', "<leader>pm", function() swap().swap_previous('@function.outer') end, 
  { buffer = true, desc = 'Swap prev functions' })

-- Capture groups (text objects)
vim.keymap.set(capt_mode, "am", capture("@function.outer"), 
  { buffer = true, desc = 'Around function' })
vim.keymap.set(capt_mode, "im", capture("@function.inner"), 
  { buffer = true, desc = 'Inner function' })

vim.keymap.set(capt_mode, "al", capture("@loop.outer"), 
  { buffer = true, desc = 'Around loop' })
vim.keymap.set(capt_mode, "il", capture("@loop.inner"), 
  { buffer = true, desc = 'Inner loop' })

vim.keymap.set(capt_mode, "ai", capture("@conditional.outer"), 
  { buffer = true, desc = 'Around conditional' })
vim.keymap.set(capt_mode, "ii", capture("@conditional.inner"), 
  { buffer = true, desc = 'Inner conditional' })

vim.keymap.set(capt_mode, "ac", capture("@class.outer"), 
  { buffer = true, desc = 'Around class' })
vim.keymap.set(capt_mode, "ic", capture("@class.inner"), 
  { buffer = true, desc = 'Inner class' })

vim.keymap.set(capt_mode, "af", capture("@call.outer"), 
  { buffer = true, desc = 'Around call' })
vim.keymap.set(capt_mode, "if", capture("@call.inner"), 
  { buffer = true, desc = 'Inner call' })

vim.keymap.set(capt_mode, "aa", capture("@parameter.outer"), 
  { buffer = true, desc = 'Around parameter' })
vim.keymap.set(capt_mode, "ia", capture("@parameter.inner"), 
  { buffer = true, desc = 'Inner parameter' })

vim.keymap.set(capt_mode, "a=", capture("@assignment.outer"), 
  { buffer = true, desc = 'Around assignment' })
vim.keymap.set(capt_mode, "i=", capture("@assignment.inner"), 
  { buffer = true, desc = 'Inner assignment' })
vim.keymap.set(capt_mode, "l=", capture("@assignment.lhs"), 
  { buffer = true, desc = 'LHS assignment' })
vim.keymap.set(capt_mode, "r=", capture("@assignment.rhs"), 
  { buffer = true, desc = 'RHS assignment' })

