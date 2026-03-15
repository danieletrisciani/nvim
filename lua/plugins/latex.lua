return {

  -- Different utilities for writing latex
  {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- vim.g.vimtex_indent_enabled = 0
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_syntax_conceal_disable = 0

      vim.g.vimtex_mappings_enabled = 0
      -- vim.g.vimtex_mappings_text_objects = { enabled = 0 }
      vim.g.localleader = " "
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_automatic = 1
      vim.g.vimtex_quickfix_open_on_warning = 0
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = 'build',
        out_dir = 'build',
      }
      vim.g.vimtex_syntax_custom_cmds = {
        {
          name = 'meter', concealchar = 'M', conceal = true
        },
      }
      -- vim.g.vimtex_syntax_custom_envs = {
      --   name = 'quantikz',
      --   math = true
      -- }
      vim.g.vimtex_syntax_custom_cmds_with_concealed_delims = {
        {
          name = 'ket',
          mathmode = 1,
          cchar_open = '|',
          cchar_close = '>',
        },
        {
          name = 'text',
          mathmode = 0,
          cchar_open = '',
          cchar_close = '',
        },
        -- Concealing for quantikz commands
        {
          name = 'gate',
          mathmode = 0,
          cchar_open = '[',
          cchar_close = ']',
        },
        {
          name = 'ctrl',
          mathmode = 0,
          cchar_open = '(',
          cchar_close = ')',
        },
        {
          name = 'targ',
          mathmode = 0,
          cchar_open = '⨁',
          cchar_close = '',
        },
        {
          name = 'lstick',
          mathmode = 0,
          cchar_open = '',
          cchar_close = '-',
        },
      }
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Commands (blue - primary actions)
          vim.api.nvim_set_hl(0, "texCmd", { fg = "#89b4fa", bold = true })
          -- Math symbols and Greek (mauve - mathematical)
          vim.api.nvim_set_hl(0, "texMathSymbol", { fg = "#cba6f7" })
          vim.api.nvim_set_hl(0, "texCmdGreek", { fg = "#cba6f7" })
          vim.api.nvim_set_hl(0, "texMathCmd", { fg = "#cba6f7" })
          -- Environments (teal - containers)
          vim.api.nvim_set_hl(0, "texCmdEnv", { fg = "#94e2d5", bold = true })
          -- Math delimiters (yellow - boundaries)
          vim.api.nvim_set_hl(0, "texMathDelimZoneTI", { fg = "#f9e2af", bold = true })
          -- Environment arguments (green - parameters)
          vim.api.nvim_set_hl(0, "texEnvArgName", { fg = "#a6e3a1" })
          vim.api.nvim_set_hl(0, "texMathEnvArgName", { fg = "#a6e3a1", italic = true })
          -- Tabular (peach - structure)
          vim.api.nvim_set_hl(0, "texTabularChar", { fg = "#fab387" })
          -- Document structure (peach - important)
          vim.api.nvim_set_hl(0, "texCmdClass", { fg = "#fab387", bold = true })
          vim.api.nvim_set_hl(0, "texCmdPackage", { link = "texCmdClass" })
          vim.api.nvim_set_hl(0, "texCmdPart", { link = "texCmdClass" })
          -- Title and Author (pink - metadata)
          vim.api.nvim_set_hl(0, "texTitleArg", { fg = "#f5c2e7" })
          vim.api.nvim_set_hl(0, "texAuthorArg", { fg = "#f5c2e7" })
        end,
      })
    end
  }
}
