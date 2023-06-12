local M = {
  "lunarvim/onedarker.nvim",
  branch = "freeze",
  priority = 1000,
  lazy = false,
}

M.config = function()
  require("onedarker").setup()
end

return M
