local M = {
	plugins = {
		-- LSP
		{
			"williamboman/mason.nvim",
			opts = {},
			lazy = false,
		},
		{
			"williamboman/mason-lspconfig.nvim",
		},
		{
			"neovim/nvim-lspconfig",
		},
		{
			"nvimtools/none-ls.nvim",
		},
		-- Completions
		{
			"hrsh7th/nvim-cmp",
			config = function()
				require("jk.plugins.completion").setup()
			end,
			event = { "InsertEnter", "CmdlineEnter" },
			dependencies = {
				"cmp-nvim-lsp",
				"cmp-buffer",
				"cmp-path",
				"cmp-cmdline",
				"cmp_luasnip",
				"cmp-calc",
			},
		},
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-cmdline" },
		{ "hrsh7th/cmp-calc" },
		{ "saadparwaiz1/cmp_luasnip" },
		{
			"L3MON4D3/LuaSnip",
			config = function()
				require("luasnip.loaders.from_lua").lazy_load()
				require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip.loaders.from_snipmate").lazy_load()
			end,
			event = "InsertEnter",
			dependencies = { "friendly-snippets" },
		},
		{ "rafamadriz/friendly-snippets" },


		-- Functionality
		{
			"ahmedkhalf/project.nvim",
			opts = {},
		},
		{
			"akinsho/toggleterm.nvim",
			lazy = false,
			config = function()
				require("jk.plugins.toggleterm").setup()
			end
		},
		{
			"kyazdani42/nvim-tree.lua",
			event = "VimEnter",
			config = function()
				require("jk.plugins.nvim-tree").setup()
			end
		},
		{
			"sourcegraph/sg.nvim",
			opts = {},
		},
		-- UI
		{
			"goolord/alpha-nvim",
			event = "VimEnter",
			config = function()
				require("jk.plugins.alpha").setup()
			end
		},
		{
			"lunarvim/colorschemes",
			priority = 1000,
			lazy = false,
			config = function()
				vim.g.colors_name = "system76"
				vim.cmd("colorscheme system76")
			end
		},
		{
			'akinsho/bufferline.nvim',
			dependencies = 'nvim-tree/nvim-web-devicons',
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
			config = function()
				vim.opt.showtabline = 2
				require("bufferline").setup()
			end
		},
		{
			"lewis6991/gitsigns.nvim",
			lazy = false,
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
			cmd = "Gitsigns",
			config = function()
				require("jk.plugins.gitsigns").setup()
			end
		},
		{
			"nvim-tree/nvim-web-devicons",
			opts = {},
		},
		{
			"stevearc/dressing.nvim",
			opts = {},
			event = "VeryLazy"
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			opts = {},
			event = "VimEnter",
		},
		-- Convenience
		{
			"jimmykodes/strman.nvim",
		},
		{
			'windwp/nvim-autopairs',
			event = "InsertEnter",
			opts = {},
		},
		{
			"numToStr/Comment.nvim",
			opts = {},
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {}
		},
		{
			"ggandor/lightspeed.nvim",
			event = "BufRead"
		},
		{
			"nvim-lua/plenary.nvim",
			cmd = { "PlenaryBustedFile", "PlenaryBustedDirectory" },
		},
		{
			"code-biscuits/nvim-biscuits",
			event = "BufRead",
			opts = {
				cursor_line_only = true,
			},
		},

		-- Telescope
		{
			"nvim-telescope/telescope.nvim",
			branch = "0.1.x",
			cmd = "Telescope",
			opts = {},
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = function()
				require("nvim-treesitter.install").update({ with_sync = true })()
			end,
			event = { "BufRead", "BufWinEnter", "BufNewFile" },
			config = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = {
						"bash",
						"css",
						"dockerfile",
						"go",
						"gomod",
						"gotmpl",
						"gowork",
						"helm",
						"html",
						"javascript",
						"json",
						"lua",
						"make",
						"markdown",
						"python",
						"query",
						"terraform",
						"vim",
						"vimdoc",
						"yaml",
					},
					sync_install = false,
					highlight = { enable = true },
					indent = { enable = true },
				})
			end
		},
		-- Go
		{
			"olexsmir/gopher.nvim",
		},
		{
			"leoluz/nvim-dap-go",
			opts = {},
		},
	}
}

function M.setup()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath
		})
	end

	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup(M.plugins, {
		defaults = { lazy = true },
	})
end

return M
