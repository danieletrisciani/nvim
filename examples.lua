-- Default folders for new projects
local py_proj = vim.fn.expand("~/Projects/") -- Programming language projects
local tex_proj = vim.fn.expand("~/Texdocs/") -- Latex projects

-- Template projects
local temp_folder = vim.fn.expand("~/.config/nvim/templates/")

-- Creates a new project
vim.keymap.set('n', '<leader>mn', function()
  vim.ui.select(
    { 'Python', 'Latex' },
    {
      prompt = 'New Project:',
    },
    function(choice)
      if not choice then return end
      local parent = nil
      local template = nil
      if choice == 'Latex' then
        parent = tex_proj
        template = "main.tex"
      elseif choice == 'Python' then
        parent = py_proj
        template = "main.py"
      end

      vim.ui.input({prompt='Project Name: '},
        function(file)
          if file == "" or not file then return end
          local folder = parent .. file
          vim.notify("New folder: " .. folder)
          vim.fn.mkdir(folder, 'p')
          vim.fn.system({ "cp", temp_folder .. template, folder })
          vim.cmd.cd(folder)
          vim.cmd("%bd!")
          vim.cmd("edit " .. template)
        end
      )
    end
  )
end, { desc = "New Project" })
