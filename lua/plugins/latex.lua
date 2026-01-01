return {

  -- Different utilities for writing latex
  {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "skim"
      vim.g.maplocalleader = " "
      vim.g.vimtex_compiler_latexmk = {
	aux_dir = 'build',  -- Directory per file ausiliari (.aux, .log, ecc.)
	out_dir = 'build',  -- Directory per PDF output
      }
    end
  }
}
