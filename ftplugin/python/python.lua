
-- Prevent multiple loading
if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = true

-- Path of the file to run
local file_name = "main.py"
local file_path = nil

-- Commands for new pane that execute the program
local function run()

  if not file_path then
    file_path = vim.fn.getcwd() .. "/main.py"
  end

  local print_name = "Executing python " .. file_name
  local echo = "echo '" .. print_name .. "\\n';"
  local env = "source ~/Documents/qe/bin/activate;"
  local py = "python " .. file_path .. ";"
  local comm = '!wezterm cli split-pane --right -- zsh -c '
  local tot_comm = comm .. '"'.. echo .. env .. py .. 'read"'
  vim.cmd(tot_comm)

end

-- Update name and path of program to update
local function update()

  file_path = vim.fn.expand('%:p')
  file_name = vim.fn.expand('%')

end

-- Execute the program pressing Enter
vim.keymap.set('n', '<CR>', run, {buffer=true, desc="Execute python"})

-- Change python file to run
vim.keymap.set('n', '<leader>cm', update, {buffer=true, desc="Update main file"} )

