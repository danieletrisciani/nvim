
-- Path of the file to run
local file_path = nil

-- Commands for new pane that execute the program
local run = function(path)
  path = path or (vim.fn.getcwd() .. "/main.py")
  local script = vim.fs.joinpath(vim.fn.stdpath("config"), "scripts", "run_python.fish")
  vim.system({ "fish", script, path }, { text = true }, function(out)
    if out.code ~= 0 then
      vim.schedule(function()
        vim.notify(out.stderr ~= "" and out.stderr or ("exit " .. out.code),
          vim.log.levels.ERROR, { title = "run_python" })
      end)
    end
  end)
end

-- Update name and path of program to update
local function update()
  file_path = vim.fn.expand('%:p')
end

-- Execute the program pressing Enter
vim.keymap.set('n', '<CR>', function() run(file_path) end, {buffer=true, desc="Execute python"})

-- Change python file to run
vim.keymap.set('n', '<leader>cm', update, {buffer=true, desc="Update main file"} )
