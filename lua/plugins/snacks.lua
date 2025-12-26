return {

  -- a collection of small QoL plugins for Neovim.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {

      -- Deal with big files
      bigfile = { enabled = true },

      -- The dashboard that shows up at the start of nvim 
      dashboard = { enabled = true },

      -- A file explorer
      explorer = { enabled = true, replace_netrw = true, trash = true },

      -- Visualize indent guides and scopes based on treesitter or indent.
      indent = { enabled = true },

      -- A better vim.ui.input
      input = { enabled = true },

      -- Graphycally improves vim.notify 
      notifier = { enabled = true, timeout = 5000 },

      -- The fuzzy finder, and a better vim.ui.select
      picker = {
	enabled = true,
	select = true,
	layout = { preset = "vscode" },
	focus = "input", -- start pickers in INSERT mode
      },

      -- When doing nvim somefile.txt, it will render the file as quickly as possible.
      quickfile = { enabled = true },

      -- Add the textobject scope to "ai" and "ii".
      -- scope = { enabled = true },

      -- Smooth scrolling
      scroll = { enabled = true },

      -- Pretty status column
      -- statuscolumn = { enabled = true },

      -- Auto-show LSP references and quickly navigate between them
      -- words = { enabled = true },

      styles = {
	notification = {
	  wo = { wrap = true } -- Wrap notifications
	}
      }
    },

    keys = {
      -- Top Pickers & Explorer
      {
	"<leader><space>",
	function()

	  local session = vim.v.this_session
	  local opts = {}

	  if session == "" or not session then
	    opts = {cwd = vim.fn.expand("%:p:h")}
	  end

	  opts = vim.tbl_extend("force", opts, { focus = "input" })
	  Snacks.picker.smart(opts)
	end,
	desc = "Smart Find Files"
      },
      { "<leader>,", function() Snacks.picker.buffers({focus = "input"}) end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.grep({focus = "input"}) end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history({focus = "input"}) end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications({focus = "input"}) end, desc = "Notification History" },
      {
	"<leader>e",
	function()
	  local opts = {}

	  -- If not in a session open the file folder
	  local session = vim.v.this_session
	  if session == "" or not session then
	    opts = {cwd = vim.fn.expand("%:p:h")}
	  end

	  Snacks.explorer(opts)
	end,
	desc = "File Explorer"
      },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      {
	"<leader>fc",
	function()
	  Snacks.picker.files({cwd = vim.fn.stdpath("config")})
	end,
	desc = "Find Config File"
      },
      {
	"<leader>ff",
	function()

	  local session = vim.v.this_session
	  local opts = {ignored = true, show_empty = true, exclude = {"__*"}}

	  if session == "" or not session then
	    opts = vim.tbl_extend("force", opts, {cwd = vim.fn.expand("%:p:h") })
	  end
	  Snacks.picker.files(opts)
	end,
	desc = "Find Files"
      },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- gh
      { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines({focus = "input"}) end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers({focus = "input"}) end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep({focus = "input"}) end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word({focus = "input"}) end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
      { "gm", function() vim.buf.rename() end, desc = "C[a]lls Outgoing" },
      {
	"<leader>ss",
	function()
	  local opts = {focus = "input", keep_parents = true}
	  Snacks.picker.lsp_symbols(opts)
	end,
	desc = "LSP Symbols"
      },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      -- { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      {
	"<leader>N",
	desc = "Neovim News",
	function()
	  Snacks.win({
	    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
	    width = 0.6,
	    height = 0.6,
	    wo = {
	      spell = false,
	      wrap = false,
	      signcolumn = "yes",
	      statuscolumn = " ",
	      conceallevel = 3,
	    },
	  })
	end,
      },
      { "<leader>wr", function() vim.cmd("SessionManager load_session") end, desc = "Session search" },
      { "<leader>ws", function() vim.cmd("SessionManager save_current_session") end, desc = "Save session" },
      { "<leader>wa", function() vim.cmd("SessionManager load_current_dir_session") end, desc = "Load session of current cwd" },
      { "<leader>wd", function() vim.cmd("SessionManager delete_session") end, desc = "Session deleter" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
	  -- Setup some globals for debugging (lazy-loaded)
	  _G.dd = function(...)
	    Snacks.debug.inspect(...)
	  end
	  _G.bt = function()
	    Snacks.debug.backtrace()
	  end

	  -- Override print to use snacks for `:=` command
	  if vim.fn.has("nvim-0.11") == 1 then
	    vim._print = function(_, ...)
	      dd(...)
	    end
	  else
	    vim.print = _G.dd 
	  end

	  -- Create some toggle mappings
	  Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
	  Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
	  Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
	  Snacks.toggle.diagnostics():map("<leader>ud")
	  Snacks.toggle.line_number():map("<leader>ul")
	  Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
	  Snacks.toggle.treesitter():map("<leader>uT")
	  Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
	  Snacks.toggle.inlay_hints():map("<leader>uh")
	  Snacks.toggle.indent():map("<leader>ug")
	  Snacks.toggle.dim():map("<leader>uD")
	end,
      })
    end,
  },
}
