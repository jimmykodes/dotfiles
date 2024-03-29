local M = {
	plugins = {
		-- LSP
		{
			"williamboman/mason.nvim",
			init = function()
				require("mason").setup()
			end,
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
		-- Functionality
		{
			"ahmedkhalf/project.nvim",
			opts = {},
		},
		{
			"akinsho/toggleterm.nvim",
			cmd = {
				"ToggleTerm",
				"TermExec",
				"ToggleTermToggleAll",
				"ToggleTermSendCurrentLine",
				"ToggleTermSendVisualLines",
				"ToggleTermSendVisualSelection",
			},
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
