local funcs = require("functions")

vim.bo.commentstring = "# %s"

vim.keymap.set("n", "<leader>x", funcs.get_uri, { desc = "get uri for prefix", buffer = true })
