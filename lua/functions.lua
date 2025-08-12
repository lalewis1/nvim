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

return M
