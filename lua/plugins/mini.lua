return {
  {
    'nvim-mini/mini.nvim',
    config = function()

      -- automatically insert matching pairs for braket characters
      require("mini.pairs").setup({})

      -- add, delete, replace, find, highlight surrounding
      require("mini.surround").setup({
	mappings = {
	  add = '<c-s>a', -- Add surrounding in Normal and Visual modes
	  delete = '<c-s>d', -- Delete surrounding
	  find = '<c-s>f', -- Find surrounding (to the right)
	  find_left = '<c-s>F', -- Find surrounding (to the left)
	  highlight = '<c-s>h', -- Highlight surrounding
	  replace = '<c-s>r', -- Replace surrounding

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
