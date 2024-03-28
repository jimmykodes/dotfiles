local M = {
	'akinsho/bufferline.nvim',
	dependencies = 'nvim-tree/nvim-web-devicons',
	event = { "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
	lazy = false,
	opts = {},
}

return M
