local M = {
	"lunarvim/colorschemes",
	priority = 1000,
	lazy = false,
}

M.config = function()
	vim.g.colors_name = "system76"
	vim.cmd("colorscheme system76")
end

return M
