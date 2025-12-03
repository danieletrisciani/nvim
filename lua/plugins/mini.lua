return {
  {
    'nvim-mini/mini.nvim',
    config = function()

      -- automatically insert matching pairs for braket characters
      require("mini.pairs").setup({})

      -- add, delete, replace, find, highlight surrounding
      require("mini.surround").setup({
	mappings = {
	  add = 'sa', -- Add surrounding in Normal and Visual modes
	  delete = 'sd', -- Delete surrounding
	  find = 'sf', -- Find surrounding (to the right)
	  find_left = 'sF', -- Find surrounding (to the left)
	  highlight = 'sh', -- Highlight surrounding
	  replace = 'sr', -- Replace surrounding

	  suffix_last = 'l', -- Suffix to search with "prev" method
	  suffix_next = 'n', -- Suffix to search with "next" method
	},
      })

      -- automatic highlighting of word under cursor
      require("mini.cursorword").setup({})
    end,
  },

  -- integrate with cmp to add brackets after autocompletition
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
  }
}
