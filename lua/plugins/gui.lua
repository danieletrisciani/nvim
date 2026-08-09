return {

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

    -- Tokyonight theme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    -- The Gruvbox theme
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000, -- Ensure the theme loads before other plugins
        config = function()
            -- Optional configuration
            require("gruvbox").setup({
                contrast = "hard", -- can be "hard", "soft" or empty string
                transparent_mode = true,
            })
        end,
    },

    -- Provides file-type icons for plugins
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true
    },

    -- replacement for the traditional vim statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            -- Returns name of session if any active
            local function sessions()
                local utils = require('session_manager.utils')
                if not utils.exists_in_session() then
                    return ""
                end

                local cwd = vim.fn.getcwd()
                local last = vim.fn.fnamemodify(cwd, ":t")
                return last or cwd
            end
            -- Returns the path of the file relative to cwd
            local function file_name()
                local utils = require('session_manager.utils')
                if not utils.exists_in_session() then
                    return vim.fn.expand("%:t")
                else
                    return vim.fn.expand("%")
                end
            end
            -- Returns the register letter when recording
            local function recording()
                if vim.fn.reg_recording() ~= "" then
                    local reg = vim.fn.reg_recording()
                    return ("● REC @" .. reg)
                end
                return ""
            end
            -- Returns the register letter when recording
            local function compile_glyphs()
                if vim.bo.filetype == 'tex' then
                    if vim.g.compile_status == 1 then
                        vim.g.compile_status_color = '#FFE066'
                    end
                    if vim.g.compile_status == 2 then
                        vim.g.compile_status_color = '#a6da95'
                    end
                    if vim.g.compile_status == 3 then
                        vim.g.compile_status_color = '#ed8796'
                    end
                    if vim.g.compile_status then
                        return ' '
                    end
                end
                return ''
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
                    lualine_a = { "mode" },
                    lualine_b = { sessions, file_name },
                    lualine_c = { },
                    lualine_x = { },
                    lualine_y = {
                        "searchcount",
                        recording,
                        {
                            compile_glyphs,
                            color = function ()
                                return {fg = vim.g.compile_status_color}
                            end,
                            separator = '',
                        },
                        compile_status,
                    },
                    lualine_z = {
                        {
                            "progress",
                            separator = '',
                            padding = { left = 1, right = 0 },
                        },
                        "location",
                    },
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
