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
		{
			"navarasu/onedark.nvim",
			priority = 1000,
			config = function()
				require("onedark").setup({
					style = "dark",
				})
				require("onedark").load()
			end,
		},
		{ "LunarVim/bigfile.nvim" },
		{
			"mfussenegger/nvim-dap",
			event = "VeryLazy",
			keys = {
				{ "<F5>", ":lua require('dap').continue()<cr>" },
				{ "<F6>", ":lua require('dap').run_last()<cr>" },
				{ "<F7>", ":lua require('dap').terminate()<cr>" },
				{ "<F8>", ":lua require('dap').restart()<cr>" },
				{ "<F9>", ":lua require('dap').run_to_cursor()<cr>" },
				{ "<F10>", ":lua require('dap').step_over()<cr>" },
				{ "<F11>", ":lua require('dap').step_into()<cr>" },
				{ "<F12>", ":lua require('dap').step_out()<cr>" },
				{ "gdl", ":lua require('dap').list_breakpoints()<cr>:copen<cr>" },
				{ "gdc", ":lua require('dap').clear_breakpoints()<cr>" },
				{ "gdb", ":lua require('dap').toggle_breakpoint()<cr>" },
				{ "gdB", ":lua require('dap').toggle_breakpoint(nil, vim.fn.input('condition: '))<cr>" },
				{ "gdL", ":lua require('dap').toggle_breakpoint(nil, nil, vim.fn.input('logpoint message: '))<cr>" },
				{ "gdh", ":lua require('dap.ui.widgets').hover()<cr>" },
				{ "<a-r>", ":lua require('dap').repl.toggle()<cr>" },
				{
					"gds",
					":lua require('dap.ui.widgets').sidebar(require('dap.ui.widgets').scopes, {width = 65}, 'vsplit').open()<cr>",
				},
			},
			config = function()
				local dap = require("dap")
				dap.defaults.fallback.switchbuf = "usevisible,usetab,uselast"
				dap.defaults.fallback.terminal_win_cmd = "10split new"
			end,
		},
		{
			"mfussenegger/nvim-dap-python",
			lazy = false,
			config = function()
				require("dap-python").setup("~/.local/share/uv/tools/debugpy/bin/python")
				require("dap-python").test_runner = "pytest"
				table.insert(require("dap").configurations.python, {
					type = "python",
					request = "launch",
					name = "jinja and allcode",
					program = "${command:pickFile}",
					jinja = true,
					justMyCode = false,
				})
			end,
			keys = {
				{ "gtm", ":lua require('dap-python').test_method()<cr>" },
				{ "gtc", ":lua require('dap-python').test_class()<cr>" },
				{ "gds", ":lua require('dap-python').debug_selection()<cr>" },
			},
		},
		{
			"nvim-neotest/neotest",
			dependencies = {
				"nvim-neotest/nvim-nio",
				"nvim-lua/plenary.nvim",
				"antoinemadec/FixCursorHold.nvim",
				"nvim-treesitter/nvim-treesitter",
				"nvim-neotest/neotest-python",
			},
			config = function()
				require("neotest").setup({
					adapters = {
						require("neotest-python"),
					},
				})
			end,
			keys = {
				{ "gtn", ":lua require('neotest').run.run()<cr>" },
				{ "gtd", ":lua require('neotest').run.run({strategy = 'dap'})<cr>" },
				{ "gta", ":lua require('neotest').run.run(vim.fn.expand('%'))<cr>" },
				{ "gts", ":lua require('neotest').summary.toggle()<cr>" },
				{ "gto", ":lua require('neotest').output_panel.toggle()<cr>" },
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			event = "VeryLazy",
			opts = {},
			keys = { { "<leader>v", ":DapVirtualTextToggle<cr>" } },
		},
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
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			event = "VeryLazy",
			config = function()
				require("nvim-treesitter.configs").setup({
					textobjects = {
						select = {
							enable = true,
							lookahead = true,
							keymaps = {
								["af"] = "@function.outer",
								["if"] = "@function.inner",
								["ac"] = "@class.outer",
								["ic"] = "@class.inner",
							},
						},
						lsp_interop = {
							enable = true,
							border = "none",
							floating_preview_opts = {},
							peek_definition_code = {
								["<leader>df"] = "@function.outer",
								["<leader>dF"] = "@class.outer",
							},
						},
					},
				})
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			event = "VeryLazy",
			config = function()
				vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true, sp = "Grey" })
				vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })
			end,
			keys = {
				{ "<leader>c", ":lua require('treesitter-context').toggle()<cr>" },
			},
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
		{
			"mistweaverco/kulala.nvim",
			ft = { "http" },
			opts = {
				contenttypes = {
					["application/sparql-query"] = {
						ft = "sparql",
					},
					["application/sparql-results+json"] = {
						ft = "json",
						formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
					},
					["application/ld+json"] = {
						ft = "json",
						formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
					},
					["text/turtle"] = {
						ft = "turtle",
					},
					["text/csv"] = {
						ft = "csv",
					},
				},
			},
			keys = {
				{ "<leader>k", ":lua require('kulala').scratchpad()<cr>" },
			},
		},
		{
			"ibhagwan/fzf-lua",
			event = "VeryLazy",
			keys = {
				{ "<a-f>", ":FzfLua files<cr>" },
				{ "<a-F>", ":FzfLua resume<cr>" },
				{ "<a-b>", ":FzfLua builtin<cr>" },
				{ "<leader>fg", ":FzfLua grep_project<cr>" },
				{ "<leader>fb", ":FzfLua buffers<cr>" },
				{ "<leader>fh", ":FzfLua helptags<cr>" },
				{ "<leader>fc", ":FzfLua colorschemes<cr>" },
			},
			config = function()
				local fzflua = require("fzf-lua")
				fzflua.register_ui_select()
			end,
		},
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets" },
			event = "VeryLazy",
			version = "1.*",
			opts = {
				keymap = { preset = "super-tab" },
				cmdline = { enabled = false },
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
					sparql_fmt = {
						command = "sparql_fmt",
						args = { "$FILENAME" },
						stdin = false,
					},
				},
				formatters_by_ft = {
					python = { "black", "isort" },
					json = { "jq" },
					lua = { "stylua" },
					markdown = { "prettier" },
					bicep = { "bicep" },
					sql = { "sqlfmt" },
					typescript = { "prettier" },
					html = { "prettier" },
					javascript = { "prettier" },
					vue = { "prettier" },
					sparql = { "sparql_fmt" },
					sh = { "shfmt" },
				},
			},
			keys = {
				{ "<leader>fm", ":lua require('conform').format({ async = true })<cr>" },
			},
		},
		{
			"brianhuster/live-preview.nvim",
			dependencies = { "ibhagwan/fzf-lua" },
			ft = { "markdown" },
			keys = {
				{ "<leader>lp", ":LivePreview start<cr>" },
			},
		},
		{
			"stevearc/oil.nvim",
			event = "VimEnter",
			opts = {
				default_file_explorer = true,
				keymaps = {
					["gs"] = function()
						require("oil").set_columns({ "mtime", "permissions", "size" })
					end,
					["gh"] = function()
						require("oil").set_columns({})
					end,
				},
			},
			keys = {
				{ "-", ":Oil<cr>" },
			},
		},
	},
	install = { colorscheme = { "habamax" } },
})
