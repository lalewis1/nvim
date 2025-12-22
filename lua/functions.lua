local M = {}

function M.get_uri()
	vim.ui.input({ prompt = "prefix: " }, function(input)
		if not input or input == "" then
			return
		end
		local url = string.format("https://kurrawong.github.io/semantic-background/ns/%s.file.json", input)
		local response = vim.fn.system({ "curl", "-s", url })
		if vim.v.shell_error ~= 0 or response == "" then
			vim.notify("Failed to fetch data", vim.log.levels.ERROR)
			return
		end
		local ok, parsed = pcall(vim.fn.json_decode, response)
		if not ok or type(parsed) ~= "table" or not parsed[input] then
			vim.notify("Bad JSON response or key not found", vim.log.levels.ERROR)
			return
		end
		vim.api.nvim_put({ parsed[input] }, "c", true, true)
	end)
end

---@summary Open a picker UI to select a Taskfile task to run.
---
--- Uses fzf-lua to present a list of available tasks from Taskfile (via `task --list --json`).
--- Each entry shows the task name.
--- Selecting a task opens a new tab and runs the task in a terminal.
---
--- The preview window shows:
---   - Task name
---   - Description (if available)
---   - Commands for the task
function M.taskpicker()
  local fzf = require("fzf-lua")
  -- Gather task list using "task --json"
  local json = vim.fn.system("task --list --json")
  if vim.v.shell_error ~= 0 or not json or json == "" then
    vim.notify("Failed to get task data (is 'task' installed and Taskfile present?)", vim.log.levels.ERROR)
    return
  end
  local data = vim.fn.json_decode(json)
  if type(data) ~= "table" or not data.tasks or type(data.tasks) ~= "table" then
    vim.notify("No tasks found in Taskfile", vim.log.levels.ERROR)
    return
  end
  local items = {}
  local task_map = {}
  for _, task in ipairs(data.tasks) do
    items[#items+1] = task.name
    task_map[task.name] = {
      summary = "task " .. task.name .. " --summary"
    }
  end
  fzf.fzf_exec(items, {
    prompt = "Run a task> ",
    preview = function(item)
      item = vim.trim(item[1])
      local task = task_map[item]
      if not task then return "(Task not found)" end
      return vim.fn.system(task.summary)
    end,
    actions = {
      ["default"] = function(selected)
        local picked = selected[1]
        local task = task_map[picked]
        if not task then return end
        vim.cmd("tabnew")
        vim.cmd("terminal task " .. task.name)
      end,
    },
  })
end

return M
