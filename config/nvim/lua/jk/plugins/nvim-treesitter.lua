local M = {
	"nvim-treesitter/nvim-treesitter",
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
	end,
	lazy = false,
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "lua", "vim", "vimdoc", "query", "go", "python", "javascript", "html" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end
}

return M
