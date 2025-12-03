return {
  
  -- Provides file-type icons for plugins
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true
  },

  -- a theme similar to vscode theme
  {
   "Mofiqul/vscode.nvim",
   lazy = false,
   priority = 1000,
   config = function()
     -- load the colorscheme here
     vim.cmd([[colorscheme vscode]])
   end,
  },

  -- replacement for the traditional vim statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
	sections = {
	  lualine_c = {'buffers'},
	  lualine_x = {
	    function()
	      local session = vim.v.this_session
	      if session == "" or not session then
		return ""
	      end
	      local path = vim.fn.getcwd()
	      -- Get the name of last folder
	      local last_component = vim.fn.fnamemodify(path, ":t")
	      return last_component or path
	    end,
	  },
	},
      })
    end,
  },

  -- enhances the command-line UI, messages, and notifications
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    presets = {
      -- enables Noice popup + makes which-key use Noice's UI
      command_palette = true,
    },
    routes = {
      {
	filter = { event = "msg_showmode" },
	view = "popup",
      },
    },
    opts = {
      lsp = {
	override = {
	  ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
	  ["vim.lsp.util.stylize_markdown"] = true,
	  ["cmp.entry.get_documentation"] = true, -- optional but recommended
	},
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  }
}
