
local nx = {"n", "x"}
local xo = {"x", "o"}
local nxo = {"n","x", "o"}

--- Remap of VimTex default textobjects ---
--- Delete ---

vim.keymap.set('n', '<leader>de', '<Plug>(vimtex-env-delete)', {
  buffer = true,
  desc = 'Env',
})

vim.keymap.set('n', '<leader>dc', '<Plug>(vimtex-cmd-delete)', {
  buffer = true,
  desc = 'Command',
})

vim.keymap.set('n', '<leader>dn', '<Plug>(vimtex-env-delete-math)', {
  buffer = true,
  desc = 'Math env',
})

vim.keymap.set('n', '<leader>dd', '<Plug>(vimtex-delim-delete)', {
  buffer = true,
  desc = 'Delimiters',
})

vim.keymap.set('n', 'K', '<Plug>(vimtex-doc-package)', {
  buffer = true,
  desc = 'Package doc',
})

--- Change ---

vim.keymap.set('n', '<leader>ce', '<Plug>(vimtex-env-change)', {
  buffer = true,
  desc = 'Env',
})

vim.keymap.set('n', '<leader>cc', '<Plug>(vimtex-cmd-change)', {
  buffer = true,
  desc = 'Command',
})

vim.keymap.set('n', '<leader>cn', '<Plug>(vimtex-env-change-math)', {
  buffer = true,
  desc = 'Math env',
})

vim.keymap.set('n', '<leader>cd', '<Plug>(vimtex-delim-change-math)', {
  buffer = true,
  desc = 'Delimiters',
})

--- Toggle ---

vim.keymap.set(nx, '<leader>tf', '<Plug>(vimtex-cmd-toggle-frac)', {
  buffer = true,
  desc = 'Fraction',
})

vim.keymap.set('n', '<leader>tc', '<Plug>(vimtex-cmd-toggle-star)', {
  buffer = true,
  desc = 'Star command',
})

vim.keymap.set('n', '<leader>ts', '<Plug>(vimtex-env-toggle-star)', {
  buffer = true,
  desc = 'Star math',
})

vim.keymap.set('n', '<leader>te', '<Plug>(vimtex-env-toggle)', {
  buffer = true,
  desc = 'Env',
})

vim.keymap.set('n', '<leader>tn', '<Plug>(vimtex-env-toggle-math)', {
  buffer = true,
  desc = 'Math env',
})

vim.keymap.set('n', '<leader>tb', '<Plug>(vimtex-env-toggle-break)', {
  buffer = true,
  desc = 'Line break',
})

vim.keymap.set(nx, '<leader>td', '<Plug>(vimtex-delim-toggle-modifier)', {
  buffer = true,
  desc = 'Delimiters',
})

vim.keymap.set("n", '<leader>tD', '<Plug>(vimtex-delim-toggle-modifier-reverse)', {
  buffer = true,
  desc = 'Reverse dels',
})

--- Select ---

vim.keymap.set(xo, 'ac', '<Plug>(vimtex-ac)', {
  buffer = true,
  desc = 'Command',
})

vim.keymap.set(xo, 'ic', '<Plug>(vimtex-ic)', {
  buffer = true,
  desc = 'Command',
})

vim.keymap.set(xo, 'ad', '<Plug>(vimtex-ad)', {
  buffer = true,
  desc = 'Delimiters',
})

vim.keymap.set(xo, 'id', '<Plug>(vimtex-id)', {
  buffer = true,
  desc = 'Delimiters',
})

vim.keymap.set(xo, 'ae', '<Plug>(vimtex-ae)', {
  buffer = true,
  desc = 'Env',
})

vim.keymap.set(xo, 'ie', '<Plug>(vimtex-ie)', {
  buffer = true,
  desc = 'Env',
})

vim.keymap.set(xo, 'an', '<Plug>(vimtex-a$)', {
  buffer = true,
  desc = 'Math Env',
})

vim.keymap.set(xo, 'in', '<Plug>(vimtex-i$)', {
  buffer = true,
  desc = 'Math Env',
})

vim.keymap.set(xo, 'aP', '<Plug>(vimtex-aP)', {
  buffer = true,
  desc = 'Section',
})

vim.keymap.set(xo, 'iP', '<Plug>(vimtex-iP)', {
  buffer = true,
  desc = 'Section',
})

vim.keymap.set(xo, 'am', '<Plug>(vimtex-am)', {
  buffer = true,
  desc = 'Item',
})

vim.keymap.set(xo, 'im', '<Plug>(vimtex-im)', {
  buffer = true,
  desc = 'Item',
})

--- Move ---

vim.keymap.set(nxo, '%', '<Plug>(vimtex-%)', {
  buffer = true,
  desc = 'To end or begin of env',
})

vim.keymap.set(nxo, ']]', '<Plug>(vimtex-]])', {
  buffer = true,
  desc = 'Section',
})

vim.keymap.set(nxo, '][', '<Plug>(vimtex-][)', {
  buffer = true,
  desc = 'End Section',
})

vim.keymap.set(nxo, '[]', '<Plug>(vimtex-[])', {
  buffer = true,
  desc = 'Section',
})

vim.keymap.set(nxo, '[[', '<Plug>(vimtex-[[)', {
  buffer = true,
  desc = 'End Section',
})

vim.keymap.set(nxo, ']e', '<Plug>(vimtex-]m)', {
  buffer = true,
  desc = 'Env',
})

vim.keymap.set(nxo, ']E', '<Plug>(vimtex-]M)', {
  buffer = true,
  desc = 'End Env',
})

vim.keymap.set(nxo, '[e', '<Plug>(vimtex-[m)', {
  buffer = true,
  desc = 'Env',
})

vim.keymap.set(nxo, '[E', '<Plug>(vimtex-[M)', {
  buffer = true,
  desc = 'End Env',
})

vim.keymap.set(nxo, ']n', '<Plug>(vimtex-]n)', {
  buffer = true,
  desc = 'Math zone',
})

vim.keymap.set(nxo, ']N', '<Plug>(vimtex-]N)', {
  buffer = true,
  desc = 'End Math zone',
})

vim.keymap.set(nxo, '[n', '<plug>(vimtex-[n)', {
  buffer = true,
  desc = 'Math zone',
})

vim.keymap.set(nxo, '[N', '<plug>(vimtex-[N)', {
  buffer = true,
  desc = 'End math zone',
})

vim.keymap.set(nxo, ']r', '<Plug>(vimtex-]r)', {
    buffer = true,
    desc = 'Frame',
})

vim.keymap.set(nxo, ']R', '<Plug>(vimtex-]R)', {
  buffer = true,
  desc = 'End Frame',
})

vim.keymap.set(nxo, '[r', '<Plug>(vimtex-[r)', {
  buffer = true,
  desc = 'Frame',
})

vim.keymap.set(nxo, '[R', '<Plug>(vimtex-[R)', {
  buffer = true,
  desc = 'End Frame',
})

vim.keymap.set(nxo, '[/', '<Plug>(vimtex-[/)', {
  buffer = true,
  desc = 'Comment',
})

vim.keymap.set(nxo, ']/', '<Plug>(vimtex-]/)', {
  buffer = true,
  desc = 'Comment',
})

vim.keymap.set(nxo, '[*', '<Plug>(vimtex-[*)', {
  buffer = true,
  desc = 'Comment line',
})

vim.keymap.set(nxo, ']*', '<Plug>(vimtex-]*)', {
  buffer = true,
  desc = 'Comment line',
})
