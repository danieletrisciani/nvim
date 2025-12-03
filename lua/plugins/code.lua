return {

  -- snippet engine
  {
    "L3MON4D3/LuaSnip", event = "VeryLazy",
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets"})
    end
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
    },
    config = function()
      require("mason-lspconfig").setup({
	ensure_installed = {
	  "pyright",
	  "ruff",
	},
      })
    end,
  },

  -- configure and manage LSP servers
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp"
    },
    config = function()

      local on_attach = function(_, _)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
	"force",
	capabilities,
	require("cmp_nvim_lsp").default_capabilities()
      )
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
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
	width = 70,
	height = 15,
      })
      vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    end,
  },

  -- nvim treesitter is a parser generator tool and an incremental parsing library.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = 'nvim-treesitter.configs',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      highlight = { enable = true, additional_vim_regex_highlighting = true},
      -- enable indentation
      indent = { enable = true },
      -- ensure these language parsers are installed
      ensure_installed = {
	"markdown",
	"markdown_inline",
	"bash",
	"lua",
	"vim",
	"vimdoc",
	"gitignore",
	"python",
	"css",
	"html",
	"javascript",
	"svelte",
	"vue",
	"tsx",
      },
      sync_install = true,
      auto_install = true,
    },
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
	},
	treesitter = {
	  label = {style = "eol"},
	},
      },
    },
    keys = {
      { "<c-s>", mode ={ "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "rr", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- provide smart, fast, and extensible autocompletion in Neovim, used alongside LSP servers, snippets. etc.
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    enabled = true,

    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local lspkind = require('lspkind')

      -- this add pre-made snippets for different programming languages
      -- require("luasnip.loaders.from_vscode").lazy_load()

      map = cmp.mapping.preset.insert({
	["<tab>"] = cmp.mapping(function(fallback)
	  if cmp.visible() then
	    cmp.confirm({ select = true, })
	  elseif luasnip.locally_jumpable(1) then
	    luasnip.jump(1)
	  else
	    fallback()
	  end
	end, { "i", "s" }),
	["<c-k>"] = cmp.mapping.select_prev_item(),
	["<c-j>"] = cmp.mapping.select_next_item(),
	["<c-space>"] = cmp.mapping.complete(),
	["<c-e>"] = cmp.mapping.abort(),
      })
      cmp.setup({
	fields = {"abbr", "menu"},
	formatting = {
	  -- format = lspkind.cmp_format({ mode = "symbol"}),
	  format = function(entry, item)
	    -- remove default icon
	    item.kind = ""
	    -- then apply lspkind
	    local lspkind_format = require("lspkind").cmp_format({ mode = "symbol" })
	    return lspkind_format(entry, item)
	  end,
	},
	mapping = map,
	completion = {
	  native_menu = false,
	  completeopt = "menu,menuone,noselect"
	  -- completeopt = "menu,menuone,preview,noselect"
	},
	snippet = {
	  expand = function(args)
	    luasnip.lsp_expand(args.body)
	  end,
	},
	-- if you want insert `(` after select function or method item
	cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done()),
	-- disable auto-completition for comments
	enabled = function()
	  local disabled = false
	  disabled = disabled or (vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt')
	  disabled = disabled or (vim.fn.reg_recording() ~= '')
	  disabled = disabled or (vim.fn.reg_executing() ~= '')
	  disabled = disabled or require('cmp.config.context').in_treesitter_capture('comment')
	  return not disabled
	end,
	sources = cmp.config.sources({
	  { name = "nvim_lsp" },
	  { name = "luasnip" },
	  { name = "buffer" },
	  { name = "path" },
	})
      })
      -- completitions for `:` cmdline setup.
      cmp.setup.cmdline(':', {
	mapping = map,
	sources = cmp.config.sources({ { name = 'path' } },
	{ { name = 'cmdline', option = { ignore_cmds = { 'man', '!' } } } }),
	-- mapping = cmp.mapping.preset.insert({ -- fix here
	--   ["<tab>"] = cmp.mapping(function(fallback)
	--     if cmp.visible() then
	--       cmp.confirm({ select = true, })
	--     elseif luasnip.locally_jumpable(1) then
	--       luasnip.jump(1)
	--     else
	--       fallback()
	--     end
	--   end, { "i", "s" }),
	--   ["<c-k>"] = cmp.mapping.select_prev_item(),
	--   ["<c-j>"] = cmp.mapping.select_next_item(),
	--   ["<c-space>"] = cmp.mapping.complete(), -- fix here
	--   ["<c-e>"] = cmp.mapping.abort(),
	--   -- ["<tab>"] = cmp.mapping.confirm({ select = true }),
	-- }),
      })
      -- completitions for `/` cmdline setup.
      cmp.setup.cmdline('/', {
	mapping = map,
	sources = {
	  { name = 'buffer' }
	},
      })
    end,
  },

  -- wraps external tools and exposes them to Neovim as pseudo-LSP sources.
  {
    "jose-elias-alvarez/null-ls.nvim",
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
}

