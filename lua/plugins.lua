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
		-- Miscellanous
		-- ##########################################################
		{ "LunarVim/bigfile.nvim" },
		{ "kylechui/nvim-surround", event = "VeryLazy" },
		{ "dstein64/nvim-scrollview", event = "VeryLazy" },
		{ "maxmx03/solarized.nvim" },
		{ "olimorris/onedarkpro.nvim" },
		{ "folke/tokyonight.nvim" },
		-- Debugmaster
		-- ##########################################################
		{
			"miroshQa/debugmaster.nvim",
			dependencies = {
				"mfussenegger/nvim-dap",
				"mfussenegger/nvim-dap-python",
				"theHamsta/nvim-dap-virtual-text",
			},
			config = function()
				local function hex_to_rgb(hex)
					hex = hex:gsub("#", "")
					return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
				end

				local function rgb_to_hex(r, g, b)
					return string.format("#%02x%02x%02x", r, g, b)
				end

				local function darken(hex_color, factor)
					local r, g, b = hex_to_rgb(hex_color)
					r = math.floor(r * factor)
					g = math.floor(g * factor)
					b = math.floor(b * factor)
					return rgb_to_hex(r, g, b)
				end

				local original_bgs = {}

				local highlight_groups = { "Normal", "NormalNC", "SignColumn" }

				vim.api.nvim_create_autocmd("User", {
					pattern = "DebugModeChanged",
					callback = function(args)
						-- Save original backgrounds
						for _, group in ipairs(highlight_groups) do
							local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
							if not original_bgs[group] and hl.bg then
								original_bgs[group] = string.format("#%06x", hl.bg)
							elseif not original_bgs[group] then
								-- fallback: use Normal bg
								local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
								if normal_hl.bg then
									original_bgs[group] = string.format("#%06x", normal_hl.bg)
								end
							end
						end
						if args.data.enabled then
							for _, group in ipairs(highlight_groups) do
								if group == "SignColumn" then
									-- Set a greenish sign column background
									vim.api.nvim_set_hl(0, group, { bg = "#3a5e3a" }) -- greenish
								else
									local bg = original_bgs[group]
									if bg then
										local new_bg = darken(bg, 0.8)
										vim.api.nvim_set_hl(0, group, { bg = new_bg })
									end
								end
							end
						else
							for _, group in ipairs(highlight_groups) do
								local bg = original_bgs[group]
								if bg then
									vim.api.nvim_set_hl(0, group, { bg = bg })
								end
							end
						end
					end,
				})

				local dap = require("dap")
				dap.defaults.fallback.switchbuf = "usevisible,usetab,uselast"
				dap.defaults.fallback.terminal_win_cmd = "10split new"

				local dappy = require("dap-python")
				dappy.setup("~/.local/share/uv/tools/debugpy/bin/python")
				dappy.test_runner = "pytest"
				table.insert(dap.configurations.python, {
					type = "python",
					request = "launch",
					name = "jinja and allcode",
					program = "${command:pickFile}",
					jinja = true,
					justMyCode = false,
				})
			end,
			keys = {
				{ "<a-d>", ":lua require('debugmaster').mode.toggle()<cr>" },
				{ "<leader>v", ":DapVirtualTextToggle<cr>" },
				{ "gtm", ":lua require('dap-python').test_method()<cr>" },
				{ "gtc", ":lua require('dap-python').test_class()<cr>" },
				{ "gds", ":lua require('dap-python').debug_selection()<cr>" },
			},
		},
		-- Neotest
		-- ##########################################################
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
				{ "<a-t>", ":lua require('neotest').summary.toggle(); require('neotest').output_panel.toggle()<cr>" },
				{ "gtn", ":lua require('neotest').run.run()<cr>" },
				{ "gtd", ":lua require('neotest').run.run({strategy = 'dap'})<cr>" },
			},
		},
		-- Treesitter
		-- ##########################################################
		{
			"nvim-treesitter/nvim-treesitter",
			dependencies = {
				"nvim-treesitter/nvim-treesitter-textobjects",
				"nvim-treesitter/nvim-treesitter-context",
			},
			event = "VeryLazy",
			config = function()
				vim.o.foldmethod = "expr"
				vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.o.foldlevel = 99

				vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true, sp = "Grey" })
				vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })
				require("treesitter-context").setup({
					enable = false,
				})

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
			keys = {
				{ "<leader>c", ":lua require('treesitter-context').toggle()<cr>" },
			},
		},
		-- CodeCompanion
		-- ##########################################################
		{
			"olimorris/codecompanion.nvim",
			config = true,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
			opts = {
				interactions = {
					chat = {
						adapter = "openai",
					},
					inline = {
						adapter = "openai",
					},
				},
			},
			keys = {
				{ "<a-c>", ":CodeCompanionChat toggle<cr>" },
				{ "<a-c>", "<esc>:CodeCompanion ", mode = "i" },
			},
		},
		-- Kulala
		-- ##########################################################
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
					["text/anot+turtle"] = {
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
		-- FZF-Lua
		-- ##########################################################
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
				{ "<leader>gb", ":FzfLua git_branches<cr>" },
				{ "<leader>gs", ":FzfLua git_status<cr>" },
			},
			config = function()
				local fzflua = require("fzf-lua")
				fzflua.register_ui_select()
			end,
		},
		-- blink.cmp
		-- ##########################################################
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
		-- Conform
		-- ##########################################################
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
						command = "sparql-formatter",
						args = { "$FILENAME" },
						stdin = true,
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
		-- Live Preview (markdown)
		-- ##########################################################
		{
			"brianhuster/live-preview.nvim",
			ft = { "markdown" },
			keys = {
				{ "<leader>lp", ":LivePreview start<cr>" },
			},
		},
		-- Oil
		-- ##########################################################
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
		-- Neogit
		-- ##########################################################
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim", -- required
				"sindrets/diffview.nvim", -- optional - Diff integration
				"ibhagwan/fzf-lua", -- optional
			},
			opts = {
				graph_style = "unicode",
				process_spinner = true,
				commit_editor = {
					show_staged_diff = false,
				},
			},
			keys = {
				{ "<a-n>", ":Neogit<cr>" },
			},
		},
		-- Diffview
		-- ##########################################################
		{
			"sindrets/diffview.nvim",
			setup = function()
				vim.opt.fillchars:append({ diff = "/" })
			end,
			opts = {
				use_icons = false,
				enhanced_diff_hl = true,
			},
			keys = {
				{ "<leader>dv", ":DiffviewOpen<cr>" },
				{ "<leader>df", ":DiffviewFileHistory %<cr>" },
			},
		},
	},
	install = { colorscheme = { "habamax" } },
})
