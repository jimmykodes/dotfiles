local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
}

function M.config()
  local alpha = require "alpha"
  local dashboard = require "alpha.themes.dashboard"
  alpha.setup(dashboard.config)
end

return M
