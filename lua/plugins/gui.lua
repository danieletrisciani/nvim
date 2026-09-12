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
                    local file_folder = vim.fn.expand('%:h:t')
                    return "  " .. file_folder
                end

                local cwd = vim.fn.getcwd()
                local last = vim.fn.fnamemodify(cwd, ":t")
                local name = last or cwd
                return "  " .. name
            end
            -- Returns the path of the file relative to cwd
            local function file_name()
                local utils = require('session_manager.utils')
                local devicons = require('nvim-web-devicons')
                local name

                -- by filename (more common — resolves extension internally)
                if not utils.exists_in_session() then
                    name = vim.fn.expand("%:t")
                else
                    name = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
                end
                if vim.bo.modified then
                    name = name .. " 󱙄 "
                end
                local icon, _ = devicons.get_icon_by_filetype(vim.bo.filetype)
                return icon .. " ".. name
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

            -- Darker gruvbox-matched statusline: the mode block uses the
            -- neutral (dark) palette variants instead of the bright ones,
            -- b sits on bg0 and c on black. Note z mirrors a and y mirrors b.
            local theme = {
                normal = {
                    a = { fg = "#ebdbb2", bg = "#665c54", gui = "bold" },
                    b = { fg = "#ebdbb2", bg = "#282828" },
                    c = { fg = "#a89984", bg = "#000000" },
                },
                insert = {
                    a = { fg = "#1d2021", bg = "#23a3aa", gui = "bold" },
                    b = { fg = "#ebdbb2", bg = "#282828" },
                    c = { fg = "#a89984", bg = "#000000" },
                },
                visual = {
                    a = { fg = "#1d2021", bg = "#e45a00", gui = "bold" },
                    b = { fg = "#ebdbb2", bg = "#282828" },
                    c = { fg = "#a89984", bg = "#000000" },
                },
                replace = {
                    a = { fg = "#ebdbb2", bg = "#cc241d", gui = "bold" },
                    b = { fg = "#ebdbb2", bg = "#282828" },
                    c = { fg = "#a89984", bg = "#000000" },
                },
                command = {
                    a = { fg = "#1d2021", bg = "#d79921", gui = "bold" },
                    b = { fg = "#ebdbb2", bg = "#282828" },
                    c = { fg = "#a89984", bg = "#000000" },
                },
                inactive = {
                    a = { fg = "#ebdbb2", bg = "#3c3836", gui = "bold" },
                    b = { fg = "#a89984", bg = "#282828" },
                    c = { fg = "#a89984", bg = "#000000" },
                },
            }

            require("lualine").setup({
                options = {
                    theme = theme,
                    globalstatus = true,  -- use global statusline
                },
                -- disabled_filetypes = {
                --   statusline = { "tex" },
                -- },
                sections = {
                    lualine_a = {
                        {
                            "mode",
                            fmt = function(str)
                                return ({ ["V-LINE"] = "VL", ["V-BLOCK"] = "VB", ["S-LINE"] = "SL", ["S-BLOCK"] = "SB" })[str]
                                    or str:sub(1, 1)
                            end,
                        },
                    },
                    lualine_b = {
                        sessions,
                        file_name,
                    },
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
