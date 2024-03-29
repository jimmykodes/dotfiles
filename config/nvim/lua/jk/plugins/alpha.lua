local M = {
	opts = {}
}

function M.setup()
	local alpha = require("alpha")
	local dashboard = require "alpha.themes.dashboard"
	alpha.setup(dashboard.config)
end

return M
