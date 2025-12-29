local fname = vim.api.nvim_buf_get_name(0)
if fname:match("docker%-compose.*%.ya?ml$") or fname:match("compose%.yaml$") then
	vim.bo.filetype = "yaml.docker-compose"
end
