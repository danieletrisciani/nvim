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
      local function sessions()
        local session = vim.v.this_session
        if not session or session == "" then
          return ""
        end

        local cwd = vim.fn.getcwd()
        local last = vim.fn.fnamemodify(cwd, ":t")
        return last or cwd
      end
      local function get_mode_bg()
        local mode = vim.fn.mode():upper()  -- N, I, V, etc.
        local hl_name = "lualine_a_" .. (mode == "N" and "normal" or "insert") -- expand for other modes
        local ok, hl = pcall(vim.api.nvim_get_hl_by_name, hl_name, true)
        if ok then
          return { fg = string.format("#%06x", hl.foreground), bg = string.format("#%06x", hl.background) }
        else
          return { fg = "#ffffff", bg = "#000000" }
        end
      end
      require("lualine").setup({
        options = {
          theme = "auto",       -- or "gruvbox", "tokyonight", etc.
          globalstatus = true,  -- use global statusline
        },
        -- disabled_filetypes = {
        --   statusline = { "tex" },
        -- },
        sections = {
          lualine_b = { "buffers" },
          lualine_c = {},
          lualine_x = { sessions},
          -- lualine_y = {},
        },
        inactive_sections = {
          lualine_c = { "buffers" },
          lualine_x = { sessions },
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
	},
	signature = {
	  enabled = false,
	  window= {
	    show_documentation = false
	  }
	}
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },

  -- Improve how the marks are shown in the signcolumn
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
	default_mappings = false,
    },
  },

  -- Allows neovim to adjust ratio between panes
  {
    'mrjones2014/smart-splits.nvim',
  },
}
