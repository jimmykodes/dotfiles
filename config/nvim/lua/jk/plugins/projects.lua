local M = {
	"ahmedkhalf/project.nvim",
}

function M.config()
	require("project_nvim").setup {}
end

return M
