
return{
  ---@module 'lazy'
  ---@type LazySpec
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- event = "VeryLazy",
    lazy = false,
    branch = "main",

    -- Disable entire built-in ftplugin mappings
    init = function()
      vim.g.no_plugin_maps = true
    end,

    -- Make builtin repeatable
    config = function()
      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,

    -- Settings
    opts = {
      move = {
	enable = true,
	set_jumps = true,
      },
      swap = {
	enable = true,
      },
      select = {
	lookahead = true,
      }
    },
  },
}
