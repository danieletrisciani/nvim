
return {
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
            ensure_installed = {
                "pyright",
                "ruff",
                "lua_ls",
                "texlab",
                "clangd",
            }
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

            --      capabilities = vim.tbl_deep_extend(
            -- "force",
            -- capabilities,
            -- require("cmp_nvim_lsp").default_capabilities()
            --      )
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            vim.lsp.config('*', {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = { Lua = { completion = { callSnippet = "Replace", enable = true } } },
            })

            local on_attach_pyright = function(client, bufnr)

                -- Enable hoverProvider
                client.server_capabilities.hoverProvider = true
                client.server_capabilities.publishDiagnostics = false
                -- Clear diagnostics from Pyright on this buffer
                vim.diagnostic.reset(vim.lsp.diagnostic.get_namespace(client.id), bufnr)
                -- Prevent future diagnostics from Pyright
            end

            -- Configure pyright
            vim.lsp.config("pyright", {

                on_attach = on_attach_pyright,
                capabilities = (function()
                    local _capabilities = vim.lsp.protocol.make_client_capabilities()
                    _capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
                    return _capabilities
                end)(),
                settings = {
                    python = {
                        analysis = {
                            useLibraryCodeForTypes = true,
                            diagnosticSeverityOverrides = {
                                reportUnusedVariable = "none",
                                reportUndefinedVariable = "none"
                            },
                            typeCheckingMode = "off", -- Set type-checking mode to off
                            diagnosticMode = "openFilesOnly", -- Disable diagnostics entirely
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
                            "--ignore", "F821", -- undefined name
                            "--ignore", "E402", -- module level import not at top of file
                            "--ignore", "E722", -- do not use bare except: (catch-all exceptions)
                            "--ignore", "E712", -- comparison to True/False using ==
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
}
