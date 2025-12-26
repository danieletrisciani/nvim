return {

  -- snippet engine
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    build = "make install_jsregexp",

    opts = {
      update_events = 'TextChanged,TextChangedI',
      store_selection_keys = "<Tab>",
      enable_autosnippets = true,
    },

    config = function(_, opts)
      local ls = require("luasnip")

      -- 1. Initialize LuaSnip with the opts defined above
      ls.setup(opts)

      -- 2. Manually trigger the loader for your custom paths
      require("luasnip.loaders.from_lua").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/snippets" }
      })
    end,
  },

  -- package manager for LSP servers, linters and formatters
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {
      ui = {
	icons = {
	  package_installed = "✓",
	  package_pending = "➜",
	  package_uninstalled = "✗"
	}
      }
    }
  },

  -- bridges mason and nvim-lspconfig, ensures servers are insalled automatically
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
      ensure_installed = {"pyright", "ruff", "lua_ls"}
    },
  },

  -- configure and manage LSP servers
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },

    config = function()

      local on_attach = function(_, _)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
	--      capabilities = vim.tbl_deep_extend(
	-- "force",
	-- capabilities,
	-- require("cmp_nvim_lsp").default_capabilities()
	--      )
      vim.lsp.config('*', {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = { Lua = { completion = { callSnippet = "Replace", enable = true } } },
      })

      local on_attach_pyright = function(client, _)

	-- Enable hoverProvider
	client.server_capabilities.hoverProvider = true
      end

      -- Configure pyright
      vim.lsp.config("pyright", {
	on_attach = on_attach_pyright,
	capabilities = (function()
	  local capabilities = vim.lsp.protocol.make_client_capabilities()
	  capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
	  return capabilities
	end)(),
	settings = {
	  python = {
	    analysis = {
	      useLibraryCodeForTypes = true,
	      diagnosticSeverityOverrides = {
		reportUnusedVariable = "warning",
	      },
	      typeCheckingMode = "off", -- Set type-checking mode to off
	      diagnosticMode = "off", -- Disable diagnostics entirely
	    },
	  },
	},
      })

      local on_attach_ruff = function(client, _)
	if client.name == "ruff" then
	  -- disable hover in favor of pyright
	  client.server_capabilities.hoverProvider = false
	end
      end

      vim.lsp.config("ruff", {
	on_attach = on_attach_ruff,
	init_options = {
	  settings = {
	    args = {
	      "--ignore",
	      "F821",
	      "--ignore",
	      "E402",
	      "--ignore",
	      "E722",
	      "--ignore",
	      "E712",
	    },
	  },
	},
      })

      vim.lsp.config("lua_ls", {
	settings = { Lua = { diagnostics = { globals = { "vim", "Snacks" } } } }
      })
	--
	--      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	-- border = "rounded",
	-- width = 70,
	-- height = 15,
	--      })
	--      vim.lsp.handlers["textDocument/signatureHelp"] =
	--      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    end,
  },

  -- allows to jump around the buffer efficiently with minimal keystrokes.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      jump = {
	nohlsearch = true,
	autojump = true,
      },
      modes = {
	char = {
	  enabled = false,
	  autohide = true,
	  highlight = { backdrop = false },
	},
      },
    },
    keys = {
      { "s", mode ={ "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "rr", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- Completion for insertmode, commands and search
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
	preset = 'super-tab',
      },

      appearance = {
	nerd_font_variant = 'mono',
      },

      completion = {
	-- By default, you may press `<c-space>` to show the documentation.
	-- Optionally, set `auto_show = true` to show the documentation after a delay.
	documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
	default = { 'lsp', 'buffer', 'snippets', 'path' },
      },

      snippets = { preset = 'luasnip' },

      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  -- wraps external tools and exposes them to Neovim as pseudo-LSP sources.
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
	sources = {
	  -- null_ls.builtins.formatting.black,
	  -- null_ls.builtins.diagnostics.ruff,
	},
      })
    end,
  },

  -- For splitting/joining blocks of code 
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      use_default_keymaps = false,
    }
  },

  -- Sofisticated commenting
  {
    "numToStr/Comment.nvim",
    opts = {

    }
  }
}

