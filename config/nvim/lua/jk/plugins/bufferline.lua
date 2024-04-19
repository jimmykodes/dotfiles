local M = {
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			show_buffer_close_icons = false,
			separator_style = "thin",
			offsets = {
				{
					filetype = "NvimTree",
					text = "Explorer",
					highlight = "PanelHeading",
					padding = 1,
				},
			},
		},
	},


}

function M.setup()
	vim.opt.showtabline = 2
	require("bufferline").setup(M.opts)
end

return M
