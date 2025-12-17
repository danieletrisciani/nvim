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
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },

    -- dependencies = {
    --   "nvim-treesitter/nvim-treesitter-textobjects",
    -- },

    opts = {
      highlight = {
	enable = true,
	additional_vim_regex_highlighting = true,
      },

      indent = { enable = true },

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
	"latex",
      },

      sync_install = true,
      auto_install = true,

      textobjects = {
	select = {
	  enable = true,
	  lookahead = true,
	  include_surrounding_whitespace = false,

	  keymaps = {
	    ["a="] = { query = "@assignment.outer", expr = true },
	    ["i="] = { query = "@assignment.inner", expr = true },
	    ["l="] = { query = "@assignment.lhs", expr = true },
	    ["r="] = { query = "@assignment.rhs", expr = true },

	    ["aa"] = { query = "@parameter.outer", expr = true },
	    ["ia"] = { query = "@parameter.inner", expr = true },

	    ["ai"] = { query = "@conditional.outer", expr = true },
	    ["ii"] = { query = "@conditional.inner", expr = true },

	    ["al"] = { query = "@loop.outer", expr = true },
	    ["il"] = { query = "@loop.inner", expr = true },

	    ["af"] = { query = "@call.outer", expr = true },
	    ["if"] = { query = "@call.inner", expr = true },

	    ["am"] = { query = "@function.outer", expr = true },
	    ["im"] = { query = "@function.inner", expr = true },

	    ["ac"] = { query = "@class.outer", expr = true },
	    ["ic"] = { query = "@class.inner", expr = true },
	  },
	},

	swap = {
	  enable = true,
	  swap_next = {
	    ["<leader>oa"] = "@parameter.inner",
	    ["<leader>om"] = "@function.outer",
	  },
	  swap_previous = {
	    ["<leader>pa"] = "@parameter.inner",
	    ["<leader>pm"] = "@function.outer",
	  },
	},

	move = {
	  enable = true,
	  set_jumps = true,
	  goto_next_start = {
	    ["]f"] = "@call.outer",
	    ["]m"] = "@function.outer",
	    ["]c"] = "@class.outer",
	    ["]i"] = "@conditional.outer",
	    ["]l"] = "@loop.outer",
	    ["]s"] = { query = "@scope", query_group = "locals" },
	    ["]z"] = { query = "@fold", query_group = "folds" },
	  },
	  goto_next_end = {
	    ["]F"] = "@call.outer",
	    ["]M"] = "@function.outer",
	    ["]C"] = "@class.outer",
	    ["]I"] = "@conditional.outer",
	    ["]L"] = "@loop.outer",
	  },
	  goto_previous_start = {
	    ["[f"] = "@call.outer",
	    ["[m"] = "@function.outer",
	    ["[c"] = "@class.outer",
	    ["[i"] = "@conditional.outer",
	    ["[l"] = "@loop.outer",
	  },
	  goto_previous_end = {
	    ["[F"] = "@call.outer",
	    ["[M"] = "@function.outer",
	    ["[C"] = "@class.outer",
	    ["[I"] = "@conditional.outer",
	    ["[L"] = "@loop.outer",
	  },
	},
	     },
    },

    -- config = function(_, opts)
    --   require("nvim-treesitter.configs").setup(opts)
    --
    --   local ts_repeat_move =
    --   require("nvim-treesitter.textobjects.repeatable_move")
    --
    --   vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    --   vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
    --
    --   vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    --   vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    --   vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    --   vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    -- end,
  },
  --  -- nvim treesitter is a parser generator tool and an incremental parsing library.
  --  {
    --    "nvim-treesitter/nvim-treesitter",
    --    lazy = false,
    --    build = ":TSUpdate",
    --    -- main = 'nvim-treesitter.configs',
    --    event = { "BufReadPre", "BufNewFile" },
    --    -- dependencies = {
      --    --   "nvim-treesitter/nvim-treesitter-textobjects",
      --    -- },
      --    opts = {
	--      highlight = { enable = true, additional_vim_regex_highlighting = true},
	--      -- enable indentation
	--      indent = { enable = true },
	--      -- ensure these language parsers are installed
	--      ensure_installed = {
	  -- "markdown",
	  -- "markdown_inline",
	  -- "bash",
	  -- "lua",
	  -- "vim",
	  -- "vimdoc",
	  -- "gitignore",
	  -- "python",
	  -- "css",
	  -- "html",
	  -- "javascript",
	  -- "svelte",
	  -- "vue",
	  -- "tsx",
	  -- "latex"
	  --      },
	  --      sync_install = true,
	  --      auto_install = true,
	  --    },
	  --  },
	  --  {
	    --    "nvim-treesitter/nvim-treesitter-textobjects",
	    --    config = function()
	      --      local h
	      --
	      --      require("nvim-treesitter.configs").setup({
		-- textobjects = {
		  --   select = {
		    --     enable = true,
		    --
		    --     -- Automatically jump forward to textobj, similar to targets.vim
		    --     lookahead = true,
		    --     include_surrounding_whitespace = false,
		    --
		    --     keymaps = {
		      --       -- You can use the capture groups defined in textobjects.scm
		      --       ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment", expr = true },
		      --       ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment", expr = true },
		      --       ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment", expr = true },
		      --       ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment", expr = true },
		      --
		      --       ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument", expr = true },
		      --       ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument", expr = true },
		      --
		      --       ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional", expr = true },
		      --       ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional", expr = true },
		      --
		      --       ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop", expr = true },
		      --       ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop", expr = true },
		      --
		      --       ["af"] = { query = "@call.outer", desc = "Select outer part of a function call", expr = true },
		      --       ["if"] = { query = "@call.inner", desc = "Select inner part of a function call", expr = true },
		      --
		      --       ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition", expr = true },
		      --       ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition", expr = true },
		      --
		      --       ["ac"] = { query = "@class.outer", desc = "Select outer part of a class", expr = true },
		      --       ["ic"] = { query = "@class.inner", desc = "Select inner part of a class", expr = true },
		      --     },
		      --   },
		      --   swap = {
			--     enable = true,
			--     swap_next = {
			  --       ["<leader>oa"] = { query = "@parameter.inner", desc = "Swap parameter with next" }, -- swap parameters/argument with next
			  --       ["<leader>om"] = { query = "@function.outer", desc = "Swap function with next"}, -- swap function with next
			  --     },
			  --     swap_previous = {
			    --       ["<leader>pa"] = { query = "@parameter.inner", desc = "Swap parameter with previous"}, -- swap parameters/argument with prev
			    --       ["<leader>pm"] = { query = "@function.outer", desc = "Swap function with previous"}, -- swap function with previous
			    --     },
			    --   },
			    --   move = {
			      --     enable = true,
			      --     set_jumps = true, -- whether to set jumps in the jumplist
			      --     goto_next_start = {
				--       ["]f"] = { query = "@call.outer", desc = "Next function call start" },
				--       ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
				--       ["]c"] = { query = "@class.outer", desc = "Next class start" },
				--       ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
				--       ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
				--
				--       -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
				--       -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
				--       ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
				--       ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
				--     },
				--     goto_next_end = {
				  --       ["]F"] = { query = "@call.outer", desc = "Next function call end" },
				  --       ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
				  --       ["]C"] = { query = "@class.outer", desc = "Next class end" },
				  --       ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
				  --       ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
				  --     },
				  --     goto_previous_start = {
				    --       ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
				    --       ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
				    --       ["[c"] = { query = "@class.outer", desc = "Prev class start" },
				    --       ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
				    --       ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
				    --     },
				    --     goto_previous_end = {
				      --       ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
				      --       ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
				      --       ["[C"] = { query = "@class.outer", desc = "Prev class end" },
				      --       ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
				      --       ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
				      --     },
				      --   },
				      -- },
				      --      })
				      --      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
				      --
				      --      -- vim way: ; goes to the direction you were moving.
				      --      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
				      --      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
				      --
				      --      -- -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
				      --      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, {expr = true})
				      --      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, {expr = true})
				      --      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, {expr = true})
				      --      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, {expr = true})
				      --    end,
				      --  },

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

