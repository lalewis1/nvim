vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

vim.keymap.set("n", "<leader>rf", ":w<cr>:tabnew<cr>:term python #<cr>i", { desc = "run file", buffer = true })
