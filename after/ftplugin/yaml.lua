local fname = vim.api.nvim_buf_get_name(0)
if fname:match("docker%-compose.*%.ya?ml$") or fname:match("compose%.ya?ml$") then
	vim.bo.filetype = "yaml.docker-compose"
	vim.keymap.set(
		"n",
		"<leader>rf",
		":w<cr>:tabnew<cr>:term docker-compose -f '#' up -d<cr>i",
		{ desc = "Run compose file", buffer = true }
	)
end
