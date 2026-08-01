-- the colorscheme should be available when starting Neovim
return {

    -- shows a popup with available key sequences and descriptions as you type a prefix key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix"
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    -- measure and display the startup time
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },

    -- helps to save, restore and manage your editing session
    {
        "Shatur/neovim-session-manager",
        lazy = false,
        config = function()
            local Path = require('plenary.path')
            local config = require('session_manager.config')
            require('session_manager').setup({
                sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
                autoload_mode = { config.AutoloadMode.LastSession },
                autosave_last_session = true, -- Automatically save last session on exit and on session switch.
                autosave_ignore_not_normal = false, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
                autosave_ignore_dirs = {"~/"}, -- A list of directories where the session will not be autosaved.
                autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
                    'gitcommit',
                    'gitrebase',
                },
                autosave_ignore_buftypes = {}, -- All buffers of these types will be closed before the session is saved.
                autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
                max_path_length = 0,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
                load_include_current = false,  -- The currently loaded session appears in the load_session UI.
            })
        end,
    },

    -- lazy.nvim
    {
        'nemanjamalesija/smart-paste.nvim',
        event = 'VeryLazy',
        config = true,
    },

    -- The Obsidian plugin for neovim
    {
      "obsidian-nvim/obsidian.nvim",
      version = "*", -- use latest release, remove to use latest commit
      ---@module 'obsidian'
      ---@type obsidian.config
      opts = {
        legacy_commands = false, -- this will be removed in 4.0.0
        workspaces = {
          {
            name = "notes",
            path = "~/cloud/Documents/Notes",
          },
        },
        picker = {
          name = "snacks.picker",
        },
      },
    },
    {
      'junegunn/fzf.vim',
      dependencies = { 'junegunn/fzf' },
    }

}
