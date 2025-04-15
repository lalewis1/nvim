local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ "maxmx03/solarized.nvim" },
		{ "LunarVim/bigfile.nvim" },
		{
			"mfussenegger/nvim-dap",
			keys = {
				{ "<F5>", ":lua require('dap').continue()<cr>" },
				{ "<F6>", ":lua require('dap').terminate()<cr>" },
				{ "<F8>", ":lua require('dap').run_to_cursor()<cr>" },
				{ "<F10>", ":lua require('dap').step_over()<cr>" },
				{ "<F11>", ":lua require('dap').step_into()<cr>" },
				{ "<F11>", ":lua require('dap').step_out()<cr>" },
				{ "gdb", ":lua require('dap').toggle_breakpoint()<cr>" },
				{ "gdB", ":lua require('dap').toggle_breakpoint(nil, vim.fn.input('condition: '))<cr>" },
				{ "gdh", ":lua require('dap.ui.widgets').hover()<cr>" },
				{ "gdr", ":lua require('dap').repl.open()<cr>" },
				{ "gds", ":lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes)<cr>" },
			},
		},
		{
			"mfussenegger/nvim-dap-python",
			lazy = false,
			config = function()
				require("dap-python").setup("~/.local/share/pipx/venvs/debugpy/bin/python")
				require("dap-python").test_runner = "pytest"
				table.insert(require("dap").configurations.python, {
					type = "python",
					request = "launch",
					name = "jinja and allcode",
					program = "${file}",
					jinja = true,
					justMyCode = false,
				})
			end,
			keys = {
				{ "gtn", ":lua require('dap-python').test_method()<cr>" },
				{ "gtf", ":lua require('dap-python').test_class()<cr>" },
				{ "gtd", ":lua require('dap-python').debug_selection()<cr>" },
			},
		},
		{ "theHamsta/nvim-dap-virtual-text", event = "VeryLazy", opts = {} },
		{
			"nvim-treesitter/nvim-treesitter",
			config = function()
				vim.o.foldmethod = "expr"
				vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.o.foldlevel = 99
				require("nvim-treesitter.configs").setup({
					highlight = { enable = true },
					indent = { enable = true },
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = "<cr>",
							node_incremental = "<cr>",
							node_decremental = "<space>",
						},
					},
				})
			end,
		},
		{ "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
		{
			"olimorris/codecompanion.nvim",
			config = true,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
			opts = {
				strategies = {
					chat = {
						adapter = "openai",
					},
					inline = {
						adapter = "openai",
					},
				},
			},
			keys = {
				{ "<a-c>", ":CodeCompanionChat<cr>" },
				{ "<a-c>", "<esc>:CodeCompanion ", mode = "i" },
			},
		},
		{ "mistweaverco/kulala.nvim", opts = {} },
		{
			"sindrets/diffview.nvim",
			opts = { use_icons = false },
			keys = {
				{ "<a-d>", ":DiffviewFileHistory %<cr>" },
			},
		},
		{
			"ibhagwan/fzf-lua",
			keys = {
				{ "<a-f>", ":FzfLua files<cr>" },
				{ "<a-b>", ":FzfLua builtin<cr>" },
				{ "<leader>fg", ":FzfLua grep_project<cr>" },
				{ "<leader>fb", ":FzfLua buffers<cr>" },
			},
		},
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets" },
			event = "VeryLazy",
			version = "1.*",
			opts = {
				keymap = { preset = "default" },
				completion = { documentation = { auto_show = true } },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
			},
			opts_extend = { "sources.default" },
		},
		{
			"stevearc/conform.nvim",
			opts = {
				formatters = {
					bicep = {
						command = "az",
						args = { "bicep", "format", "-f", "$FILENAME" },
						stdin = false,
					},
				},
				formatters_by_ft = {
					python = { "black", "isort" },
					lua = { "stylua" },
					markdown = { "prettier" },
					bicep = { "bicep" },
				},
			},
			keys = {
				{ "<leader>fm", ":lua require('conform').format({ async = true })<cr>" },
			},
		},
    {
      'brianhuster/live-preview.nvim',
      dependencies = { 'ibhagwan/fzf-lua' },
      keys = {
        { "<leader>lp", ":LivePreview start<cr>" }
      }
    }
	},
	install = { colorscheme = { "vim" } },
})
