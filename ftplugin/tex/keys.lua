
--- Remap of VimTex default mappings ---

-- Table of Content
vim.keymap.set('n', '<leader>ll', '<Plug>(vimtex-compile)', {
  buffer = true,
  desc = 'Compile',
})

-- Table of Content
vim.keymap.set('n', '<leader>lt', '<Plug>(vimtex-toc-open)', {
  buffer = true,
  desc = 'TOC',
})

-- Info 
vim.keymap.set('n', '<leader>li', '<Plug>(vimtex-info)', {
  buffer = true,
  desc = 'Info',
})

-- View the generated PDF
vim.keymap.set('n', '<leader>lv', '<Plug>(vimtex-view)', {
  buffer = true,
  desc = 'View',
})

-- Shows VimTex LOG
vim.keymap.set('n', '<leader>lq', '<Plug>(vimtex-log)', {
  buffer = true,
  desc = 'Log',
})

-- Stop continuos compilation
vim.keymap.set('n', '<leader>lk', '<Plug>(vimtex-stop)', {
  buffer = true,
  desc = 'Stop',
})

-- Shows compilation errors
vim.keymap.set('n', '<leader>le', '<Plug>(vimtex-errors)', {
  buffer = true,
  desc = 'Errors',
})

-- Compile already compiled output
vim.keymap.set('n', '<leader>lo', '<Plug>(vimtex-compile-output)', {
  buffer = true,
  desc = 'Compile output',
})

-- Shows VimTex status
vim.keymap.set('n', '<leader>lg', '<Plug>(vimtex-status)', {
  buffer = true,
  desc = 'Status',
})

-- Clean the quickfix log
vim.keymap.set('n', '<leader>lc', '<Plug>(vimtex-clean)', {
  buffer = true,
  desc = 'Clean',
})

-- Open the context menu
vim.keymap.set('n', '<leader>la', '<Plug>(vimtex-context-menu)', {
  buffer = true,
  desc = 'Context menu',
})
