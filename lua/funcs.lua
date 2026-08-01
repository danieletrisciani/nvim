-- Default folders for new projects
local roots = {
    tex_folder = vim.fn.expand('~/cloud/Projects'),
    pr_folder = vim.fn.expand('~/cloud/Texdocs'),
}

-- Template projects
local temp_folder = vim.fn.expand("~/.config/nvim/templates/")

local M = {}

M.new_session = function() vim.cmd("SessionManager save_current_session") end
M.restore_session = function() vim.cmd("SessionManager load_current_dir_session") end

M.new_tab = function ()
    local script = vim.fs.joinpath(vim.fn.stdpath("config"), "scripts", "new_tab.fish")
    vim.system({ "fish", script}, { text = true })
end

M.toggle_conceal = function ()
    if vim.wo.conceallevel == 2 then
        vim.wo.conceallevel = 0
        vim.notify("Conceal ON")
    else
        vim.wo.conceallevel = 2
        vim.notify("Conceal OFF")
    end
end

M.toggle_lualine = function()
    if vim.o.laststatus == 0 then
        vim.o.laststatus = 3  -- o 2 per statusline per finestra
    else
        vim.o.laststatus = 0
    end
end

M.picker_session = function()
    require("snacks").picker.pick({
        title = "Sessions",
        name = "picker-sessions",
        finder = function ()

            local utils = require('session_manager.utils')
            local sessions = utils.get_sessions()
            local items = {}

            for index, session in ipairs(sessions) do
                table.insert(items, {
                    idx = index,
                    file = utils.shorten_path(session.dir),
                    text = session.filename,
                })
            end

            return items
        end,
        -- After pressing enter
        format = "filename",
        layout = {
            backdrop = true,
            hidden = { "preview" },
            layout = {
                backdrop = false,
                row = 3,
                width = 0.4,
                min_width = 30,
                min_height = 2,
                height = function()
                    local n = #require('session_manager.utils').get_sessions()
                    return math.min(n + 2, 15)
                end,
                border = true,
                box = "vertical",
                title = "{title} {live} {flags}",
                { win = "input", height = 1, border = "bottom"},
                { win = "list", border = "hpad" },
            },
        },
        icons = {
            files = {
                enabled = false,
            }
        },
        formatters = {
            file = {
                filename_only = true,
            }
        },
        -- Keys to manipulate the sessions
        confirm = "load_session",
        win = {
            input = {
                keys = {
                    ["<C-d>"] = {"delete_session", mode = { "n", "i" }, desc = "delete session"},
                    ["dd"] = {"delete_session", mode = { "n" }, desc = "delete session"},
                    ["<C-u>"] = {"update", mode = { "n", "i" }, desc = "update sessions"},
                },
            },
        },
        -- Azione quando selezioni
        actions = {
            -- Load the selected session
            load_session = function(picker, item)
                if not item then
                    picker:close()
                    return
                end

                local utils = require('session_manager.utils')
                local session = require('session_manager')
                vim.cmd('wa') -- Save current changes
                session.save_current_session()
                picker:close() -- Close the UI

                vim.schedule(function()
                    utils.load_session(item.text, true)
                end)

            end,
            -- Delete the selected session
            delete_session = function (picker, item)
                if not item then
                    picker:close()
                    return
                end

                local utils = require('session_manager.utils')
                utils.delete_session(item.text)
                picker:find()
            end,
            -- Updates sessions
            update = function (picker, _)
                local utils = require('session_manager.utils')
                local count = 0
                for _, root in ipairs(roots) do
                    for name, type in vim.fs.dir(root) do
                        if type == 'directory' then
                            local dir = root .. '/' .. name
                            local out = utils.save_external_session(dir)
                            if out == 0 then
                                count = count + 1
                            end
                        end
                    end
                end
                vim.notify(('Registered %d new project sessions'):format(count))
                picker:find()
            end
        },
    })
end

M.toggle_autosave = function()
    vim.g.auto_save = not vim.g.auto_save

    if vim.g.auto_save then
        vim.notify("Enabled Autosave", vim.log.levels.INFO, { title = "Autosave" })
    else
        vim.notify("Disabled Autosave", vim.log.levels.WARN, { title = "Autosave" })
    end
end

M.new_project = function(choice)
    local config = {
        Latex = { parent = roots.tex_folder, template = "tex", main = "main.tex" },
        Python = { parent = roots.pr_folder, template = "python", main = "main.py"},
        Cpp = { parent = roots.pr_folder, template = "cpp", main = "main.cpp"},
    }

    local alias = {
        Latex = "Latex",
        Python = "Python",
        Cpp = "C++",
    }

    local selected = config[choice]
    if not selected then return end

    local new_project_template = function(name)
        if not name or name == "" then return end

        -- Define local variables so they don't leak
        local folder = selected.parent .. '/' .. name
        local template = selected.template

        if vim.fn.isdirectory(folder) == 1 then
            vim.notify("Project already exists: " .. folder, vim.log.levels.ERROR)
            return
        end

        vim.notify("Creating " .. choice .. " project: " .. name)

        vim.fn.mkdir(folder, 'p')
        -- Use the template folder variable you defined at the top of your init.lua
        vim.fn.system({ "cp", "-r", temp_folder .. template .. "/.", folder })
        if vim.v.shell_error ~= 0 then
            vim.notify("Template copy failed: " .. template, vim.log.levels.ERROR)
            return
        end

        -- Safely exit current session
        vim.cmd('silent! wa')

        -- Move into the new project and create the session
        vim.cmd.cd(vim.fn.fnameescape(folder))
        vim.cmd("silent! %bd!")
        vim.cmd.edit(vim.fn.fnameescape(selected.main))
        vim.fn.system({ 'git', 'init' })
        M.new_session()
    end

    vim.ui.input({ prompt = alias[choice] .. ' Project Name: ' }, new_project_template)
end

-- Open input ui to choose a name for the new buffer being created
M.new_buffer = function()
    vim.ui.input({ prompt = "Buffer name: " }, function(name)
        if not name or name == "" then return end
        vim.cmd.edit(vim.fn.fnameescape(name))
    end)
end

return M
