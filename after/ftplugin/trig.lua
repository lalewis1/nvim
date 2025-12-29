vim.bo.commentstring = "# %s"
vim.keymap.set("n", "<leader>v", ":!riot --validate %<cr>", { desc = "validate with riot", buffer = true })
