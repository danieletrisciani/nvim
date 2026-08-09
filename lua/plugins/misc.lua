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
            local utils = require('session_manager.utils')
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
            local dir = config.session_filename_to_dir(utils.get_last_session_filename()).filename
            -- Harpoon needs this to currently load the file list
            vim.cmd.cd(dir)
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
    -- fzf search. This is used mainly by vimtex toc search.
    {
      'junegunn/fzf.vim',
      dependencies = { 'junegunn/fzf' },
    },

    -- automatic list continuation/renumbering for markdown
    {
        "gaoDean/autolist.nvim",
        ft = "markdown",
        config = function()
            require("autolist").setup()

            vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
            vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
            -- vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
            -- vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
            -- vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
            -- vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

            -- cycle through list types with dot-repeat
            -- vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
            -- vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })
            --
            -- vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
            -- vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
            --
            -- vim.keymap.set("n", "<leader>tt", require("autolist").invert_todo, { desc = "Toggle todo" })
        end,
    },

    -- Move between files with a keystroke
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()

            -- vim.keymap.set("n", "<leader>aa", function() harpoon:list():add() end)
            -- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            -- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
            -- vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
            -- vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
            -- vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
            -- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
            -- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
        end,
    },

    -- Moves between TODOs in the buffers
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = true
        }
    }
}
