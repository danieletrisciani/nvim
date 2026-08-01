return {

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

    -- For splitting/joining blocks of code 
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {
            use_default_keymaps = false,
            -- disable the plugin for latex
            langs = {
                latex = {
                },
            },
        },
    },

    -- Sofisticated commenting (To fix for textobjects)
    {
        "numToStr/Comment.nvim",
        opts = {}
    },

    -- Autocomplete brackets and other characters
    {
        'altermo/ultimate-autopair.nvim',
        event={'InsertEnter','CmdlineEnter'},
        branch='v0.6', --recommended as each new version will have breaking changes
        opts={
            internal_pairs={
                {'[',']',fly=true,dosuround=true,newline=true,space=true},
                {'(',')',fly=true,dosuround=true,newline=true,space=true},
                {'{','}',fly=true,dosuround=true,newline=true,space=true},
                {'"','"',suround=true,multiline=false},
                {"'","'",suround=true,cond=function(fn) return not fn.in_lisp() or fn.in_string() end,alpha=true,nft={'tex'},multiline=false},
                {'`','`',cond=function(fn) return not fn.in_lisp() or fn.in_string() end,nft={'tex'},multiline=false},
                {'``',"''",ft={'tex'}},
                {'```','```',newline=true,ft={'markdown'}},
                {'<!--','-->',ft={'markdown','html'},space=true},
                {'"""','"""',newline=true,ft={'python'}},
                {"'''","'''",newline=true,ft={'python'}},
                {'$','$',fly=true,dosuround=true,newline=true,space=true,ft={'tex'}},
            },
        },
    },

    -- A collection of lightweight plugins
    {
        'nvim-mini/mini.nvim',
        config = function()

            -- add, delete, replace, find, highlight surrounding
            require("mini.surround").setup({
                mappings = {
                    add = '<c-s>a', -- Add surrounding in Normal and Visual modes
                    delete = '<c-s>d', -- Delete surrounding
                    find = '<c-s>f', -- Find surrounding (to the right)
                    find_left = '<c-s>F', -- Find surrounding (to the left)
                    highlight = '<c-s>h', -- Highlight surrounding
                    replace = '<c-s>r', -- Replace surrounding

                    suffix_last = 'l', -- Suffix to search with "prev" method
                    suffix_next = 'n', -- Suffix to search with "next" method
                },
            })

            -- automatic highlighting of word under cursor
            require("mini.cursorword").setup({})
        end,
    }
}

