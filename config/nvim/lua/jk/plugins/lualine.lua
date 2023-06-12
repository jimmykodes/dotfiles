local M = {
  "nvim-lualine/lualine.nvim",
  lazy=false,
}

function M.config()
  require("lualine").setup()
end

return M
