local function exclude_env_files(client, bufnr)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	if fname:match("%.env$") then
		client.stop()
	end
end

return {
	cmd = { "bash-language-server", "start" },
	on_attach = exclude_env_files,
	settings = {
		bashIde = {
			-- Glob pattern for finding and parsing shell script files in the workspace.
			-- Used by the background analysis features across files.

			-- Prevent recursive scanning which will cause issues when opening a file
			-- directly in the home directory (e.g. ~/foo.sh).
			--
			-- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
		},
	},
	filetypes = { "bash", "sh" },
	root_markers = { ".git" },
}
