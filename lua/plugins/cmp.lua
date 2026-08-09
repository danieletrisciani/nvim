
-- keep case of first char, useful on latex files
local keepcase = function (a, items)
    local keyword = a.get_keyword()
    local correct, case
    if keyword:match('^%l') then
        correct = '^%u%l+$'
        case = string.lower
    elseif keyword:match('^%u') then
        correct = '^%l+$'
        case = string.upper
    else
        return items
    end

    -- avoid duplicates from the corrections
    local seen = {}
    local out = {}
    for _, item in ipairs(items) do
        local raw = item.insertText
        if raw:match(correct) then
            local text = case(raw:sub(1,1)) .. raw:sub(2)
            item.insertText = text
            item.label = text
        end
        if not seen[item.insertText] then
            seen[item.insertText] = true
            table.insert(out, item)
        end
    end
    return out
end

return {
    {
        "xzbdmw/colorful-menu.nvim",
        -- snippet engine
    },

    -- Snippet engine
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

    -- Configure lua_ls for editing Neovim config
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- Completion for insertmode, commands and search
    {
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            {
                "micangl/cmp-vimtex",
                dependencies = {
                    {
                        "saghen/blink.compat",
                        version = "*",
                        lazy = true,
                        opts = {},
                    },
                },
            },
        },
        --- @module 'blink.cmp'
        --- @type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'default',
                ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
                ['<Tab>'] = { 'snippet_forward',  'select_next', 'fallback' },

                ['<C-d>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-e>'] = { 'hide', 'fallback' },
                ['<CR>'] = { 'accept', 'fallback' },

                ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
                ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

                ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
            },

            appearance = {
                nerd_font_variant = 'mono',
            },

            completion = {
                documentation = {
                    auto_show = false,
                    auto_show_delay_ms = 500,
                },
                list = {
                    selection = {
                        auto_insert = false,
                    },
                },
                menu = {
                    draw = {
                        treesitter = { 'lsp' },
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    }
                }
            },

            sources = {
                -- default = { 'lsp', 'buffer', 'snippets', 'path'},
                default = { 'lazydev', 'omni', 'lsp', 'buffer', 'snippets', 'path' },
                providers = {
                    vimtex = {
                        name = "vimtex",
                        module = "blink.compat.source",
                        score_offset = 100,
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                    buffer = {
                        -- keep case of first char, useful on latex files
                        transform_items = keepcase
                    },
                    path = {
                        -- don't suggest filesystem paths for `/` in tex math mode
                        enabled = function()
                            return vim.bo.filetype ~= "tex"
                                or vim.fn["vimtex#syntax#in_mathzone"]() == 0
                        end,
                    },
                },
            },

            snippets = {
                preset = 'luasnip',
            },

            fuzzy = { implementation = 'prefer_rust_with_warning' },

            -- Shows a signature help window while you type arguments for a function
            signature = { enabled = true },
        },
    },

}
