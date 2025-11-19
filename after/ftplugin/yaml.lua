local funcs = require("functions")

vim.keymap.set("n", "<leader>x", funcs.get_uri, { desc = "get uri for prefix", buffer = true })

local fname = vim.api.nvim_buf_get_name(0)
if fname:match("docker%-compose.*%.ya?ml$") or fname:match("compose%.yaml$") then
	vim.bo.filetype = "yaml.docker-compose"
end
